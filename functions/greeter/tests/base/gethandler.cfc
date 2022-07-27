component extends="tests.Test" {

	function setup() {
		super.setup();
		base = new functions.greeter.cfml.app.Application();
	}

	function teardown() {
		super.teardown();
	}

	function test_getHandler() {
		event = {handler: "foo:bar"};
		actual = base.getHandler(event);
		assert(actual.component == "foo");
		assert(actual.function == "bar");
	}

	function test_getHandler_default() {
		actual = base.getHandler();
		assert(actual.component == "main");
		assert(actual.function == "handler");
	}

	function test_getHandler_sqs() {
		event = getMockEvent("sqs-receive-message");
		actual = base.getHandler(event);
		assert(actual.component == "aws");
		assert(actual.function == "sqs");
	}

	function test_getHandler_s3() {
		event = getMockEvent("s3-put");
		actual = base.getHandler(event);
		assert(actual.component == "aws");
		assert(actual.function == "s3");
	}

	function test_getHandler_apiGateway() {
		event = getMockEvent("apigateway-aws-proxy");
		actual = base.getHandler(event);
		assert(actual.component == "aws");
		assert(actual.function == "apiGateway");
	}

	function test_getHandler_cloudWatch() {
		event = getMockEvent("cloudwatch-scheduled-event");
		actual = base.getHandler(event);
		assert(actual.component == "aws");
		assert(actual.function == "cloudWatch");
	}

	function getMockEvent(event) {
		local.content = FileRead(ExpandPath("/functions/greeter/tests/events/#arguments.event#.json"));
		return DeserializeJSON(local.content);
	}

}
