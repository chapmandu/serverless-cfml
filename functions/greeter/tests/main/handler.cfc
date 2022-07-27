component extends="tests.Test" {

	function setup() {
		super.setup();
		main = new functions.greeter.cfml.app.main();
	}

	function teardown() {
		super.teardown();
	}

	function test_handler() {
		actual = main.handler();
		expected = ["ToO HoT tO hAnDlE!"];
		assert(actual[1] == expected[1]);
	}

}
