component extends="tests.Test" {

	function setup() {
		super.setup();
		greeter = new functions.greeter.cfml.app.greeter();
	}

	function teardown() {
		super.teardown();
	}

	function test_hello() {
		actual = greeter.hello();
		expected = "Hello World!";
		assert(actual == expected);
	}

}
