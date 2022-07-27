component extends="tests.Test" {

	function setup() {
		super.setup();
		greeter = new functions.greeter.cfml.app.greeter();
	}

	function teardown() {
		super.teardown();
	}

	function test_greeter_handler() {
		actual = greeter.handler();
		assert(StructKeyExists(actual, "uuid"));
	}

}
