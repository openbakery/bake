import jetbrains.buildServer.configs.kotlin.v2019_2.*
import jetbrains.buildServer.configs.kotlin.v2019_2.buildFeatures.swabra
import jetbrains.buildServer.configs.kotlin.v2019_2.buildSteps.exec
import jetbrains.buildServer.configs.kotlin.v2019_2.buildSteps.script
import jetbrains.buildServer.configs.kotlin.v2019_2.triggers.finishBuildTrigger
import jetbrains.buildServer.configs.kotlin.v2019_2.triggers.vcs

version = "2025.07"


project {

	val build = Build()
	buildType(build)

}

class Build : BuildType({
	name = "Build And Test"

	vcs {
		root(DslContext.settingsRoot)
	}

	steps {
		exec {
			path = "./runTests"
		}
	}

	features {
		swabra { }
	}

	triggers {
		vcs {
		}
	}
})

