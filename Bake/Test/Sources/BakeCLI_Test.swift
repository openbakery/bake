import ArgumentParser
import Bake
import BakeTestHelper
import Hamcrest
import Testing

@testable import BakeCLI

@MainActor
class BakeCLI_Test {

	@Test
	func has_bootstrap() {
		assertThat(BakeCLI.configuration, present())
		#expect(BakeCLI.configuration.subcommands.first is BootstrapCommand.Type)
	}
}
