local StoreSignage = {}

StoreSignage.Brand = {
	wordmark = "SUPERSTORE",
	tag = "3AM",
	supportLine = "OPEN LATE",
	checkoutHeader = "CHECKOUT",
}

StoreSignage.Aisles = {
	{ id = "aisle_01", numeral = "01", label = "PRODUCE" },
	{ id = "aisle_02", numeral = "02", label = "CLEANING" },
	{ id = "aisle_03", numeral = "03", label = "HOUSEHOLD" },
	{ id = "aisle_04", numeral = "04", label = "DAIRY" },
	{ id = "aisle_05", numeral = "05", label = "SNACKS" },
	{ id = "aisle_06", numeral = "06", label = "SODA" },
	{ id = "aisle_07", numeral = "07", label = "FROZEN" },
	{ id = "aisle_08", numeral = "08", label = "CANNED" },
}

StoreSignage.Checkout = {
	{ id = "lane_1", numeral = "1", copy = "LANE 1" },
	{ id = "lane_2", numeral = "2", copy = "LANE 2" },
	{ id = "lane_3", numeral = "3", copy = "LANE 3" },
	{ id = "lane_4", numeral = "4", copy = "LANE 4" },
}

StoreSignage.Freezer = {
	header = "FREEZER",
	subheader = "KEEP DOORS CLOSED",
}

StoreSignage.Staff = {
	employeesOnly = "EMPLOYEES ONLY",
	stockroom = "STOCKROOM",
	freezer = "FREEZER",
	noEntry = "NO ENTRY",
	wetFloor = "WET FLOOR",
	exit = "EXIT",
	backDoor = "BACK DOOR",
	noticeBoard = "NOTICE BOARD",
}

StoreSignage.SaleCard = {
	familyId = "night_deal",
	headline = "NIGHT DEAL",
	prices = {
		"2 FOR $5",
		"SAVE $1",
		"3 FOR $7",
	},
}

StoreSignage.DepartmentHeaders = {
	front = "CUSTOMER CARE",
	checkout = "CHECKOUT",
	frozen = "FROZEN",
	backstock = "BACKSTOCK",
	receiving = "RECEIVING",
}

return StoreSignage
