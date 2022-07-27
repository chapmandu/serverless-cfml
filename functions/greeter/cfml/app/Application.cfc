component {

	this.name = "serverlessCFML";
	this.sessionManagement = false;
	this.clientManagement = false;
	this.setClientCookies = false;
	this.mappings["/app"] = GetDirectoryFromPath(GetCurrentTemplatePath());

	// inject services
	this.utils = new services.utils();

	// the function invoked by aws lambda
	public any function fuselessEvent(event, context) {
		local.eventObject = this.utils.deserializeIfJSON(arguments.event);
		local.handler = this.getHandler(local.eventObject);
		return this.runHandler(local.handler, local.eventObject);
	}

	// TODO: move the AWS service portion of this to a global component to be "injected"
	public struct function getHandler(event = {}) {
		local.handler = arguments.event.handler ?: "main:handler";
		if (StructKeyExists(arguments.event, "httpMethod")) {
			local.handler = "aws:apiGateway";
		} else if ((arguments.event.source ?: "") == "aws.events") {
			local.handler = "aws:cloudWatch";
		} else if (
			StructKeyExists(arguments.event, "Records")
			&& StructKeyExists(arguments.event.Records[1], "s3")
		) {
			local.handler = "aws:s3";
		} else if (
			StructKeyExists(arguments.event, "Records")
			&& (arguments.event.Records[1].eventSource ?: "") == "aws:sqs"
		) {
			local.handler = "aws:sqs";
		}
		local.returnValue = {component: ListFirst(local.handler, ":"), function: ListLast(local.handler, ":")};
		return local.returnValue;
	}

	public object function runHandler(handler, event) {
		local.component = new "#arguments.handler.component#"(arguments.event);
		return local.component[arguments.handler.function]( );
	}

	// only used when called via API Gateway
	// can include the cfml template from the cgi.path eg: /hello.cfc
	// or explicity call a cfc function or cfm template
	public function onRequest(string path) {
		// include arguments.path;
		include "index.cfm";
	}

	public function getLambdaContext() {
		// see https://docs.aws.amazon.com/lambda/latest/dg/java-context-object.html
		return GetPageContext().getRequest().getAttribute("lambdaContext");
	}

	public void function logger(string msg) {
		getLambdaContext().getLogger().log(arguments.msg);
	}

	public string function getRequestID() {
		if (IsNull(getLambdaContext())) {
			// not running in lambda
			if (!request.keyExists("_request_id")) {
				request._request_id = CreateUUID();
			}
			return request._request_id;
		} else {
			return getLambdaContext().getAwsRequestId();
		}
	}

}
