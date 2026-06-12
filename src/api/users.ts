import { Request, Response } from "express";
import crypto from "crypto";
import { v4 as uuidv4 } from "uuid";
import { respondWithError, respondWithJSON } from "./json.js";
import { createUser, getUser } from "../db/queries/users.js";
import { User } from "../db/schema.js";

export async function handlerUsersCreate(req: Request, res: Response) {
  try {
    const nameRaw = req.body?.name;
    const name = typeof nameRaw === "string" ? nameRaw.trim() : "";
    if (!name) {
      return respondWithError(res, 400, "Invalid 'name' provided");
    }

    const apiKey = generateApiKey();
    const userId = uuidv4();

    await createUser({
      id: userId,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
      name,
      apiKey,
    });
    const user = await getUser(apiKey);
    if (user) {
      respondWithJSON(res, 201, user);
    } else {
      console.error("User created but not found for apiKey", apiKey);
      respondWithError(res, 500, "Couldn't retrieve user");
    }
  } catch (err) {
    console.error(err);
    respondWithError(res, 500, "Couldn't create user");
  }
}

export async function handlerUsersGet(req: Request, res: Response, user: User) {
  respondWithJSON(res, 200, user);
}

function generateApiKey(): string {
  return crypto.randomBytes(32).toString("hex");
}
