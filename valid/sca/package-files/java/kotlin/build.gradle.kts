plugins {
    id("java")
}
//checkov:skip=io.netty:netty-codec[BC_LIC_1]: io.netty:netty-codec
//checkov:skip=PRISMA-2021-0055: PRISMA-2021-0055
//checkov:skip=CVE-2023-34462: CVE-2023-34462

group = "org.example"
version = "1.0-SNAPSHOT"

repositories {
    mavenCentral()
}

dependencies {
    testImplementation("org.junit.jupiter:junit-jupiter-api:5.8.1")
    testRuntimeOnly("org.junit.jupiter:junit-jupiter-engine:5.8.1")
    implementation(platform("software.amazon.awssdk:bom:2.17.267"))
    implementation("software.amazon.awssdk:sso") {
        because("Needed to automatically enable AWS SSO login, see https://stackoverflow.com/a/67824174")
    }
    implementation("software.amazon.awssdk:s3") {
        exclude("software.amazon.awssdk", "netty-nio-client")
    }
    implementation("com.itextpdf:itext-core:9.3.0")
    implementation("com.mysql:mysql-connector-j:8.3.0")
}

tasks.getByName<Test>("test") {
    useJUnitPlatform()
}