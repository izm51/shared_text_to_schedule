import { ChatCompletion } from "openai/resources/chat/completions";
import { askToExtractSchedule } from "./client";
import { CalndarSchedule, Schedule } from "./domain";

export async function extractSchedule(text: string): Promise<Schedule> {
  const response: ChatCompletion = await askToExtractSchedule(text);
  const contentJson = response.choices[0].message.content as string;
  const schedule = CalndarSchedule.fromJSON(contentJson);
  return schedule;
}
