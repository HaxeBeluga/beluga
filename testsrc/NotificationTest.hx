package;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
#if php
import beluga.core.Beluga;
import beluga.module.notification.Notification;
#end

class NotificationTest
{
	private var timer:Timer;
	#if php
	private var notif : Notification;
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
		this.notif = this.beluga.getModuleInstance(Notification);
		#end
	}

	@After
	public function tearDown():Void
	{
	}

	@Test
	public function testGetNotifications():Void
	{
		#if php
		var sur = Beluga.getInstance().getModuleInstance(Notification);
		sur.get();
		var list = sur.getNotifications();
		Assert.isTrue(list != null);
		#end
	}

	@Test
	public function createNewNotification():Void
	{
		#if php
		notif.create({
			title: "Test",
			text: "Test",
			user_id: TEST_ID
		})
		Assert.isTrue(notif.exist(TEST_ID));
		#end
	}
}