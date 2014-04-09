package;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
#if php
import beluga.core.Beluga;
import beluga.module.survey.Survey;
#end

class SurveyTest
{
	private var timer:Timer;
	#if php
	private var survey : Survey;
	private var beluga : Beluga;
	#end
	private var TEST_ID: Int = 1;


	public function new()
	{

	}

	@Before
	public function setup():Void
	{
		#if php
		this.beluga = Beluga.getInstance();
		this.survey = this.beluga.getModuleInstance(Survey);
		#end
	}

	@After
	public function tearDown():Void
	{
	}

	@Test
	public function testGetSurveysList():Void
	{
		#if php
		var sur = Beluga.getInstance().getModuleInstance(Survey);
		sur.get();
		var list = sur.getSurveysList();

		Assert.isTrue(list != null);
		#end
	}

	@Test
	public function testGetVote():Void
	{
		#if php
		var sur = Beluga.getInstance().getModuleInstance(Survey);

		Assert.isTrue(sur.getVote() != null);
		#end
	}

}