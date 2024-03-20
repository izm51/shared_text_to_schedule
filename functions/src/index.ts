import { onRequest, Request } from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";

import { extractSchedule as extractScheduleFunc } from "./features/openai/service";
import { Schedule } from "./features/openai/domain";

export const healthCheck = onRequest((request, response) => {
  logRequest(request);
  response.send("I'm OK!");
});

export const extractSchedule = onRequest(async (request, response) => {
  // TODO: 認証追加
  logRequest(request);
  const schedule: Schedule = await extractScheduleFunc(request.body.text);
  response.send(schedule);
});

function logRequest(request: Request) {
  logger.info(`Request: ${request.method} ${request.url}`);
}
