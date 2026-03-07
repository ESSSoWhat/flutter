// Gradle 8.x does not support Java 25. Use JDK 17 for this project.
val javaMajor = JavaVersion.current().majorVersion.toIntOrNull() ?: 0
if (javaMajor >= 25) {
    throw GradleException(
        "Android build requires JDK 17 or 21. Current: Java $javaMajor. " +
        "Set JAVA_HOME to JDK 17 (or in IDE: Gradle JDK → 17)."
    )
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
