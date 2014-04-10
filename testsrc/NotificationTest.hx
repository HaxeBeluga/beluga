package;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import beluga.module.notification.Notification;
import beluga.core.Beluga;

class NotificationTest
{
	private var timer:Timer;

	public function new()
	{

	}

	@BeforeClass
	public function beforeClass():Void
	{
	}

	@AfterClass
	public function afterClass():Void
	{
	}

	@Before
	public function setup():Void
	{
	}

	@After
	public function tearDown():Void
	{
	}

	@Test
	public function testGetNotifications():Void
	{
		var sur = Beluga.getInstance().getModuleInstance(Notification);
		sur.get();
		var list = sur.getNotifications();

		Assert.isTrue(list != null);
	}

	@AsyncTest
	public function testAsyncExample(factory:AsyncFactory):Void
	{
		var handler:Dynamic = factory.createHandler(this, onTestAsyncExampleComplete, 300);
		timer = Timer.delay(handler, 200);
	}

	private function onTestAsyncExampleComplete():Void
	{
		Assert.isFalse(false);
	}


	/**
	* test that only runs when compiled with the -D testDebug flag
	*/
	@TestDebug
	public function testExampleThatOnlyRunsWithDebugFlag():Void
	{
		Assert.isTrue(true);
	}
}