TOOLS_PACKAGE_PATH := Tools
TOOLS_PATH := ${TOOLS_PACKAGE_PATH}/.build/release
SWIFT_FORMAT_TARGETS := $(shell \
	find "Sources" "Tests" "Tools" \
		-name "*.swift" -type f \
		-not -path "*/.build/*" \
		-not -path "*/*.generated.swift" \
)


.PHONY: build-tools
build-tools:
	@swift build -c release --package-path ${TOOLS_PACKAGE_PATH} --product swift-format
	@swift build -c release --package-path ${TOOLS_PACKAGE_PATH} --product mockolo

.PHONY: lint
lint:
	@${TOOLS_PATH}/swift-format lint --configuration .swift-format ${ADDITIONAL_OPTIONS} ${SWIFT_FORMAT_TARGETS}

.PHONY: lint-strict
lint-strict: ADDITIONAL_OPTIONS = --strict
lint-strict: lint

.PHONY: format
format:
	@${TOOLS_PATH}/swift-format format --in-place --configuration .swift-format ${SWIFT_FORMAT_TARGETS}

.PHONY: gyb
gyb:
	@Scripts/run-gyb.sh

.PHONY: gen-mock
gen-mock:
	@${TOOLS_PATH}/mockolo \
		--sourcedirs Sources/Ethereum \
		--destination Sources/Ethereum/Mock.generated.swift

.PHONY: build
build:
	@swift build

.PHONY: test
test:
	@swift test

.PHONY: clean
clean:
	@rm -rf \
		./.build \
		./${TOOLS_PACKAGE_PATH}/.swiftpm \
		./${TOOLS_PACKAGE_PATH}/.build
