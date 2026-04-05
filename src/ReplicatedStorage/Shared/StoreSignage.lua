local StoreSignage = {}

StoreSignage.Brand = {
	wordmark = "SUPERSTORE",
	tag = "3AM",
	supportLine = "OPEN LATE",
}

StoreSignage.Aisles = {
	{ id = "aisle_01", numeral = "01", label = "PRODUCE" },
	{ id = "aisle_02", numeral = "02", label = "CLEANING" },
	{ id = "aisle_03", numeral = "03", label = "HOUSEHOLD" },
	{ id = "aisle_04", numeral = "04", label = "DAIRY" },
	{ id = "aisle_05", numeral = "05", label = "SNACKS + SODA" },
	{ id = "aisle_06", numeral = "06", label = "FROZEN" },
}

StoreSignage.SaleCards = {
	{ id = "night_price", copy = "NIGHT PRICE" },
	{ id = "save_now", copy = "SAVE NOW" },
	{ id = "two_for_one", copy = "2 FOR 1" },
}

StoreSignage.Checkout = {
	{ id = "register_1", copy = "REGISTER 1" },
	{ id = "register_2", copy = "REGISTER 2" },
	{ id = "cash_out", copy = "CASH OUT" },
	{ id = "lane_closed", copy = "LANE CLOSED" },
	{ id = "bag_here", copy = "BAG HERE" },
}

StoreSignage.Freezer = {
	{ id = "frozen_header", copy = "FROZEN" },
	{ id = "keep_door_closed", copy = "KEEP DOOR CLOSED" },
	{ id = "cold_storage", copy = "COLD STORAGE" },
}

StoreSignage.Stockroom = {
	{ id = "employees_only", copy = "EMPLOYEES ONLY" },
	{ id = "backstock", copy = "BACKSTOCK" },
	{ id = "payroll", copy = "PAYROLL" },
	{ id = "safety_check", copy = "SAFETY CHECK" },
	{ id = "receiving", copy = "RECEIVING" },
}

StoreSignage.Decals = {
	{ id = "price_strip", copy = "PRICE STRIP" },
	{ id = "barcode_tab", copy = "BARCODE" },
	{ id = "hazard_stripe", copy = "HAZARD STRIPE" },
	{ id = "floor_arrow", copy = "FLOOR ARROW" },
	{ id = "wet_floor", copy = "WET FLOOR" },
	{ id = "receipt_stub", copy = "RECEIPT STUB" },
	{ id = "payment_icons", copy = "PAYMENT ICONS" },
	{ id = "this_side_up", copy = "THIS SIDE UP" },
	{ id = "receiving_tag", copy = "RECEIVING TAG" },
	{ id = "cooler_tag", copy = "COOLER SERVICE" },
}

return StoreSignage
