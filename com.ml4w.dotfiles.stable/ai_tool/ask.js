const { GoogleGenerativeAI } = require("@google/generative-ai");

// Access your API key environment variable
const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

async function generateWithFallback(question) {
  // Keeping your requested model names
  const primaryModelName = "gemini-2.5-flash";
  const fallbackModelName = "gemini-2.5-flash-lite";

  // ✅ Attempt 1: Primary Model (Flash)
  try {
    const model = genAI.getGenerativeModel({ model: primaryModelName });
    console.log(`Gemini 2.5 Flash is thinking for "${question}"...`);
    
    const result = await model.generateContent(question);
    const response = await result.response;
    return response.text();

  } catch (error) {
    // ⚠️ Attempt 2: Fallback (Lite)
    console.log(`\n⚠️ Flash failed (${error.message}). Switching to Flash-Lite...`);
    
    try {
      const fallbackModel = genAI.getGenerativeModel({ model: fallbackModelName });
      console.log(`Gemini 2.5 Flash-Lite is thinking for "${question}"...`);
      
      const result = await fallbackModel.generateContent(question);
      const response = await result.response;
      return response.text() + "\n\n(Generated via Flash-Lite due to high traffic)";
      
    } catch (fallbackError) {
      throw new Error(`Failed on both models. Check your internet or API Quota.`);
    }
  }
}

async function main() {
  // capture all arguments after "ask"
  const question = process.argv.slice(2).join(" ");

  if (!question) {
    console.log("Usage: ask <your question>");
    return;
  }

  try {
    const text = await generateWithFallback(question);

    console.log("\n---------------------------------");
    console.log(text);
    console.log("---------------------------------\n");

  } catch (e) {
    console.error("Error:", e.message);
  }
}

main();
