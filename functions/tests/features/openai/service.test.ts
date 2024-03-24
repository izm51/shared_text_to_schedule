import { jest, describe, test, expect } from "@jest/globals";
import { ChatCompletion } from "openai/resources/chat/completions";

import { ScheduleExtractService } from "../../../src/features/openai/service";
import { OpenaiClient } from "../../../src/features/openai/client";

const mockResponse: ChatCompletion = {
  id: "chatcmpl-8dfaITYvUkRvyN3oGyyGH7UFGSrDT",
  object: "chat.completion",
  created: 1704465334,
  model: "gpt-3.5-turbo-1106",
  choices: [
    {
      index: 0,
      message: {
        role: "assistant",
        content: `\
        {
          "title": "東京クリスマスマーケット202X",
          "start_date": "20231123",
          "start_time": "160000",
          "end_date": "20231225",
          "end_time": "213000",
          "details": "日本最大級のクリスマスマーケット。飲食店25店舗、雑貨30店舗が集結。音楽団の演奏などステージパフォーマンスも。",
          "location": "明治神宮外苑 聖徳記念絵画館前・総合球技場"
        }`,
      },
      logprobs: null,
      finish_reason: "stop",
    },
  ],
  usage: { prompt_tokens: 688, completion_tokens: 167, total_tokens: 855 },
  system_fingerprint: "fp_99cc374e39",
};

describe("extractSchedule", () => {
  const openaiClientMock = new OpenaiClient({
    openaiApiKey: "dummy",
    useMock: true,
  });

  jest
    .spyOn(openaiClientMock, "askToExtractSchedule")
    .mockResolvedValue(mockResponse);

  const scheduleExtractService = new ScheduleExtractService(openaiClientMock);

  test("Call the function main must return message", async () => {
    expect(await scheduleExtractService.extractSchedule("dummy text")).toEqual({
      title: "東京クリスマスマーケット202X",
      startDate: "20231123",
      startTime: "160000",
      endDate: "20231225",
      endTime: "213000",
      details:
        "日本最大級のクリスマスマーケット。飲食店25店舗、雑貨30店舗が集結。音楽団の演奏などステージパフォーマンスも。",
      location: "明治神宮外苑 聖徳記念絵画館前・総合球技場",
    });
  });
});
