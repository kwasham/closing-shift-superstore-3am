local StoreRollout = {}

StoreRollout.RootFolderName = "FallbackArtSlice"
StoreRollout.HooksFolderName = "Sprint7ArtHooks"
StoreRollout.RuntimeGroupsFolderName = "Sprint7RuntimeGroups"
StoreRollout.ZoneFolderPrefix = "Zone_"

StoreRollout.TierAZoneOrder = {
	"Lobby",
	"EntranceTransition",
	"Checkout",
	"Queue",
	"AislesWest",
	"AislesCenter",
	"AislesEast",
	"FreezerTransition",
	"Freezer",
	"StockroomTransition",
	"Stockroom",
}

StoreRollout.TierBZoneOrder = {
	"Perimeter",
	"StaffHall",
	"SightlineCeiling",
	"SecondaryEndcaps",
	"TaskCorners",
}

StoreRollout.CaptureHooks = {
	"LobbyCaptureAnchor",
	"CheckoutCaptureAnchor",
	"AisleWestCaptureAnchor",
	"AisleCenterCaptureAnchor",
	"AisleEastCaptureAnchor",
	"FreezerCaptureAnchor",
	"StockroomCaptureAnchor",
	"FrontContinuityAnchor",
	"FreezerContinuityAnchor",
	"StockroomContinuityAnchor",
	"BlackoutReadAnchor",
	"MimicReadAnchor",
	"UpdateShotAnchor",
}

StoreRollout.SignageHooks = {
	"LobbyBrandHook",
	"CheckoutHeaderHook",
	"AisleWestHook",
	"AisleCenterHook",
	"AisleEastHook",
	"FreezerHeaderHook",
	"StockroomDoorHook",
	"ExitHook",
}

StoreRollout.RuntimeGroups = {
	"AisleMarkers",
	"CategoryHeaders",
	"CheckoutMarkers",
	"StaffSigns",
	"SaleCards",
	"EmergencyRead",
	"FixtureBanks",
	"BrandSigns",
	"PlaceholderMasks",
}

StoreRollout.ZoneTiers = {
	Lobby = "A",
	EntranceTransition = "A",
	Checkout = "A",
	Queue = "A",
	AislesWest = "A",
	AislesCenter = "A",
	AislesEast = "A",
	FreezerTransition = "A",
	Freezer = "A",
	StockroomTransition = "A",
	Stockroom = "A",
	Perimeter = "B",
	StaffHall = "B",
	SightlineCeiling = "B",
	SecondaryEndcaps = "B",
	TaskCorners = "B",
}

StoreRollout.GroupRoles = {
	AisleMarkers = "aisle_marker",
	CategoryHeaders = "category_header",
	CheckoutMarkers = "checkout_marker",
	StaffSigns = "staff_sign",
	SaleCards = "sale_card",
	EmergencyRead = "emergency_read",
	FixtureBanks = "fixture_bank",
	BrandSigns = "brand_sign",
	PlaceholderMasks = "placeholder_mask",
}

return StoreRollout
