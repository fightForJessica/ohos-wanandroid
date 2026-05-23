
export class BannerResponse {
	data?: BannerData[] = [];
	errorCode?: number = 0;
	errorMsg?: string = "";
}

export class BannerData {
	desc?: string = "";
	id?: number = 0;
	imagePath?: string = "";
	isVisible?: number = 0;
	order?: number = 0;
	title?: string = "";
	type?: number = 0;
	url?: string = "";
}