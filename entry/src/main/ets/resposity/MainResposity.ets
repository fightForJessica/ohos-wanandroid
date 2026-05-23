import { ArticalResponse } from "../model/mainpage/ArticalData";
import { BannerResponse } from "../model/mainpage/BannerData";
import { ProjectTreeResponse } from "../model/mainpage/ProjectData";
import BaseResposity from "./BaseResposity";

export class MainResposity extends BaseResposity {

  async fetchBannerData(): Promise<BannerResponse> {
    let url = "banner/json"
    return await this.get<BannerResponse>(url)
  }

  async fetchArticalData(page: number): Promise<ArticalResponse> {
    let url = `article/list/${page}/json`
    return await this.get<ArticalResponse>(url)
	}

  async fetchProjectType(): Promise<ProjectTreeResponse> {
    let url = "project/tree/json"
		return await this.get<ProjectTreeResponse>(url);
	}

}