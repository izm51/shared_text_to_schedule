import { ChatCompletion } from "openai/resources/chat/completions";
import { askToExtractSchedule } from "./client";
import { CalndarSchedule } from "./domain";

export async function extractSchedule(text: string): Promise<CalndarSchedule> {
  const response: ChatCompletion = await askToExtractSchedule(text);
  const contentJson = response.choices[0].message.content as string;
  const schedule = CalndarSchedule.fromJSON(contentJson);
  return schedule;
}
