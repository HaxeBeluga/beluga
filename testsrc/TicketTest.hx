package;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
#if php
import beluga.core.Beluga;
import beluga.module.notification.Notification;
#end

class TicketTest
{
	#if php
	private var ticket : Ticket;
	private var beluga : Beluga;
	#end
	private var TEST_ID: Int = 1;

	public function new() {

	}

	@Before
	public function setup(): Void {
		#if php
		this.beluga = Beluga.getInstance();
		this.ticket = this.beluga.getModuleInstance(Ticket);
		#end
	}

	@After
	public function tearDown():Void {

	}

	@Test
	public function submitANewTicket():Void {
		#if php
		ticket.submit({
			title: "Test",
			message: "Test",
			asignee: "User"
		});
		Assert.isTrue(ticket.isOpen(TEST_ID));
		#end
	}

	@Test
	public function closeTicket():Void {
		#if php
		ticket.submit({
			title: "Test",
			message: "Test",
			asignee: "User"
		});
		ticket.close({ id: TEST_ID });
		Assert.isTrue(ticket.isClosed(TEST_ID));
		#end
	}

	@Test
	public function reopenTicket():Void {
		#if php
		ticket.submit({
			title: "Test",
			message: "Test",
			asignee: "User"
		});
		ticket.close({ id: TEST_ID });
		ticket.reopen({ id: TEST_ID });
		Assert.isFalse(ticket.isClosed(TEST_ID));
		#end
	}

	@Test
	public function addLabel():Void {
		#if php
		ticket.createNewLabel("Test");
		Assert.isTrue(ticket.labelExist(TEST_ID));
		#end
	}

	@Test
	public function removeLabel():Void {
		#if php
		ticket.addLabel({ name: "Test" });
		ticket.deleteLabel({ id: TEST_ID });
		Assert.isFalse(ticket.labelExist("Test"));
		#end
	}

	@Test
	public function createComment():Void {
		#if php
		ticket.submit({
			title: "Test",
			message: "Test",
			asignee: "User"
		});
		ticket.comment({
			id: TEST_ID,
			message:
		})
		Assert.isTrue(ticket.getTicketMessageCount(TEST_ID) == 1);
		#end
	}

	@Test
	public function getLabelsListEmpty():Void {
		#if php
		Assert.isTrue(ticket.getTLabelsList().length == 0);
		#end
	}

	@Test
	public function getLabelsListNotEmpty():Void {
		#if php
		ticket.addLabel({ name: "Test" });
		Assert.isTrue(ticket.getTLabelsList().length != 0);
		#end
	}

	@Test
	public function getTicketLabels():Void {
		#if php
		ticket.submit({
			title: "Test",
			message: "Test",
			asignee: "User"
		});
		ticket.addLabel({ name: "Test" });
		Assert.isTrue(ticket.getTicketLabels().first() == "Test");
		#end
	}

}