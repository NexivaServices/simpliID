allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    // On Windows, Flutter plugins may live in the Pub cache on a different drive
    // (e.g. C:\Users\...\Pub\Cache) while this project is on another drive (e.g. D:\...).
    // For those plugins, relocating build outputs under this repo can make the Kotlin
    // compiler try to relativize paths across drive roots and crash.
    val rootDrive = rootProject.projectDir.toPath().root?.toString()?.lowercase()
    val projectDrive = project.projectDir.toPath().root?.toString()?.lowercase()
    if (rootDrive == null || projectDrive == null || rootDrive == projectDrive) {
        val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
        project.layout.buildDirectory.value(newSubprojectBuildDir)
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
