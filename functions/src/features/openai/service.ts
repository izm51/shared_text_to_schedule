import { ChatCompletion } from "openai/resources/chat/completions";
import { OpenaiClient } from "./client";
import { CalndarSchedule } from "./domain";

export class ScheduleExtractService {
  private client: OpenaiClient;

  constructor(client: OpenaiClient) {
    this.client = client;
  }

  async extractSchedule(text: string): Promise<CalndarSchedule> {
    const response: ChatCompletion = await this.client.askToExtractSchedule(
      text
    );
    const contentJson = response.choices[0].message.content as string;
    const schedule = CalndarSchedule.fromJSON(contentJson);
    return schedule;
  }
}
