package;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import beluga.module.survey.Survey;
import beluga.core.Beluga;

class SurveyTest
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
	public function testGetSurveysList():Void
	{
		var sur = Beluga.getInstance().getModuleInstance(Survey);
		sur.get();
		var list = sur.getSurveysList();

		Assert.isTrue(list != null);
	}

	@Test
	public function testGetVote():Void
	{
		var sur = Beluga.getInstance().getModuleInstance(Survey);

		Assert.isTrue(sur.getVote() != null);
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