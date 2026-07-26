# Timezone handling

Mobile uses the device-local timezone when constructing calendar boundaries and converts them to UTC for Drift predicates. Start is inclusive and end exclusive. Dart local `DateTime` applies the platform timezone database for midnight and DST behavior. Backend validates IANA zone identifiers with `zoneinfo`; UTC is the fallback when none is supplied.
