component extends="tests.Test" {

	function setup() {
		super.setup();
		greeter = new functions.greeter.cfml.app.greeter();
	}

	function teardown() {
		super.teardown();
	}

	function test_goodbye() {
		actual = Serialize(greeter.goodbye());
		expected = Serialize(["Goodbye cruel world!"]);
		assert(actual == expected);
	}

}
