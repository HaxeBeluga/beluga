import massive.munit.TestSuite;

import SurveyTest;
import TicketTest;
import NotificationTest;
import DataCheckerTest;
import ExampleTest;
import FileUploadTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();

		add(SurveyTest);
		add(TicketTest);
		add(NotificationTest);
		add(DataCheckerTest);
		add(ExampleTest);
		add(FileUploadTest);
	}
}
