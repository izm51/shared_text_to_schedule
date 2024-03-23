import * as functions from "firebase-functions";
import * as logger from "firebase-functions/logger";

import { ScheduleExtractService } from "./features/openai/service";
import { CalndarSchedule } from "./features/openai/domain";
import { OpenaiClient } from "./features/openai/client";

const openaiApiKey = functions.params.defineSecret("OPENAI_API_KEY");

const useAuthentication = (process.env.USE_AUTHENTICATION || "true") === "true";

export const healthCheck = functions.https.onCall(() => {
  return { message: "I'm OK!" };
});

export const extractSchedule = functions
  .runWith({
    secrets: [openaiApiKey],
  })
  .https.onCall(async (data: any, context: functions.https.CallableContext) => {
    logger.info("[extractSchedule]: called");

    if (useAuthentication && !context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "unauthenticated"
      );
    }

    logger.info("[extractSchedule]: data:", data);
    if (!data.text) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "invalid request parameters"
      );
    }

    const openaiClient = new OpenaiClient({
      openaiApiKey: openaiApiKey.value(),
      useMock: (process.env.OPENAI_USE_MOCK || "true") === "true",
    });
    const extractService = new ScheduleExtractService(openaiClient);
    const schedule: CalndarSchedule = await extractService.extractSchedule(
      data.text
    );
    return schedule;
  });
