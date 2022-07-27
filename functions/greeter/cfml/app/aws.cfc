component {

	public function init(event, context) {
		this.event = arguments.event;
		this.context = arguments.context;
		return this;
	}

	public struct function s3() {
		local.s3 = this.event.records[1].s3;
		return {"message": "You put #local.s3.object.key# into #local.s3.bucket.name# s3 bucket"};
	}

	public struct function sqs() {
		local.message = this.event.records[1];
		local.queue = ListLast(local.message.eventSourceARN, ":");
		return {"message": "You received message #local.message.messageId# from #local.queue#"};
	}

	public struct function apiGateway() {
		return {"message": "API gateway made a #this.event.httpMethod# request to #this.event.path#"};
	}

	public struct function cloudWatch() {
		return {"message": "Cloudwatch ran #this.event['detail-type']# #this.event.id#"};
	}

}
