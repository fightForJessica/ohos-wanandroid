

export class ArticalResponse {
	data?: ArticalResponseData = new ArticalResponseData();
	errorCode?: number = 0;
	errorMsg?: string = "";
}

export class ArticalResponseData {
	curPage?: number = 0;
	datas?: ArticalResponseDetail[] = [];
	offset?: number = 0;
	over?: boolean = false;
	pageCount?: number = 0;
	size?: number = 0;
	total?: number = 0;
}

export class ArticalResponseDetail {
	adminAdd?: boolean = false;
	apkLink?: string = "";
	audit?: number = 0;
	author?: string = "";
	canEdit?: boolean = false;
	chapterId?: number = 0;
	chapterName?: string = "";
	collect?: boolean = false;
	courseId?: number = 0;
	desc?: string = "";
	descMd?: string = "";
	envelopePic?: string = "";
	fresh?: boolean = false;
	host?: string = "";
	id?: number = 0;
	isAdminAdd?: boolean = false;
	link?: string = "";
	niceDate?: string = "";
	niceShareDate?: string = "";
	origin?: string = "";
	prefix?: string = "";
	projectLink?: string = "";
	publishTime?: number = 0;
	realSuperChapterId?: number = 0;
	selfVisible?: number = 0;
	shareDate?: number = 0;
	shareUser?: string = "";
	superChapterId?: number = 0;
	superChapterName?: string = "";
	tags?: ArticalTag[] = [];
	title?: string = "";
	type?: number = 0;
	userId?: number = 0;
	visible?: number = 0;
	zan?: number = 0;
}

export class ArticalTag{
	name?: string = "";
	url?: string = ""
}