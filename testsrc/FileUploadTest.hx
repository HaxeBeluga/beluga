package;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
#if php
import beluga.core.Beluga;
import beluga.module.fileupload.FileUpload;
#end

class FileUploadTest
{
	private var timer:Timer;
	#if php
	private var fileupload : Fileupload;
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
		this.fileupload = this.beluga.getModuleInstance(Fileupload);
		#end
	}

	@After
	public function tearDown():Void
	{
	}

	@Test
	public function testAddExtension():Void
	{
		#if php
		fileupload.addextension({ name: "jpg" });
		Assert.isTrue(fileupload.extensionIsValid("jpg"));
		#end
	}

	@Test
	public function testDeleteExtension():Void
	{
		#if php
		fileupload.addextension({ name: "jpg" });
		fileupload.deleteextension({ name: "jpg" });
		Assert.isTrue(fileupload.extensionIsValid("jpg") == false);
		#end
	}

	@Test
	public function testExtensionIsValid():Void
	{
		#if php
		fileupload.addextension({ name: "jpg" });
		Assert.isTrue(fileupload.extensionIsValid("jpg") == false);
		#end
	}

	@Test
	public function testExtensionIsNotValid():Void
	{
		#if php
		fileupload.addextension({ name: "jpg" });
		Assert.isTrue(fileupload.extensionIsValid("jpg") == false);
		#end
	}
}