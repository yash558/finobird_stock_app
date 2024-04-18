class FAQ {
  final String questions;
  final List<String> answers;

  FAQ({
    required this.questions,
    required this.answers,
  });
}

List<FAQ> faqList = [
  FAQ(
    questions: "What is FinoBird?",
    answers: [
      "FinoBird helps you to track your investments in Indian stock market with ease. FinoBird collects the information from different sources, unifies them and provide filters to enable you to personalize your feed.",
      "The mobile application also has communities at company level, sector level and topic level for you to interact with relevant people and clarify your doubts.",
      "FinoBird also has WhatsApp and Telegram bots enabled with AI which give latest information about selected company at fingertips. You can try the bot here FinoBird.",
    ],
  ),
  FAQ(
    questions: "What exactly is tracking of companies?",
    answers: [
      "Tracking of company specifically means following the company and keeping oneself updated about the things happening related to the company. Because, there will be updates related to the company regularly. It is important to know the positives and negatives happening to the company. With this, user can take a better decision with conviction whether to buy-more/sell/hold the positions."
    ],
  ),
  FAQ(
    questions: "Why FinoBird?",
    answers: [
      "It helps you save significant amount of time to track the companies. Typically the time to track the companies is reduced from 4-5 hours per week to 5-10 minutes per week. With its personalization feature, it helps you block all the irrelevant information in the stock market.",
      "Its communities at company level, sector level and topic level enable you to ask relevant questions to a closed group. The accuracy of the answer is expected to be more rather than other social networking apps.",
      "The AI enabled bots add convenience to get the latest information.",
    ],
  ),
  FAQ(
    questions:
        "How is FinoBird different from other finance apps in the market?",
    answers: [
      "FinoBird's vision is to build a community of retail investors who could retire wealthy and early. FinoBird is not about us. FinoBird is about you. Its pure purpose is finding the place in the hearts of the users. We are sure you would love it too."
    ],
  ),
  FAQ(
    questions: "Does FinoBird offer any advisory services?",
    answers: [
      "No, at present, FinoBird does not offer any advisory services. But it enables you to take your buying/selling decisions on your own with conviction."
    ],
  ),
  FAQ(
    questions: "Who is FinoBird for?",
    answers: [
      "It is for every hard-working individual who wants to invest and grow their money by making it work for you."
    ],
  ),
  FAQ(
    questions: "Is it only for investors?",
    answers: [
      "FinoBird provides information on different stocks and it has communities as well. We believe traders also can benifit from this."
    ],
  ),
];
