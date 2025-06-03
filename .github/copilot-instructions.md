
# 🧠 AI Agent Instructions for Flutter Project (Boilerplate Style)

You are working inside a Flutter project that follows a strict modular clean architecture with a structured folder organization, reusable component system, and styling conventions. Please follow these instructions carefully:

---

## 📁 Folder & Architecture Rules
- Use **clean architecture pattern**: split into `data`, `domain`, `presentation` layers.
- Every feature is located under `lib/features/feature_name/`.
  - `data/`: contains `models`, `repositories`, `sources`.
  - `domain/`: contains `entities`, `usecases`, `repositories`.
  - `presentation/`: contains `pages`, `blocs`, `components`.
- Each feature has its own `module.dart` for routing and DI.
- Do **not** import classes directly from nested folders — instead, use `xxx.dart` barrel files (e.g., `models.dart`, `components.dart`).

---

## 🧱 UI Development Rules
- Follow **atomic design**: build UI using widgets from `lib/core/components/{atom,molecule,organism}`.
- Use these reusable widgets:
  - `RegularInput` → input fields
  - `SmartNetworkImage` → images
  - `ArrowButton`, `MiniElevatedButton` → buttons
  - `CardShadow` → cards
  - `SearchTextInput`, `DropdownInput` → search & dropdown
  - `Skeleton`, `SkeletonAnimation` → loading states
  - `TextTitle`, `TextSubtitle`, etc. → from `core/components/atom/text/text.dart`

---

## 🎨 Styling Conventions
- Use `.withAlpha(value)` instead of `.withOpacity(value)`
- Use `Dimens.dpXX.width` or `.height` for spacing, not `SizedBox`.
- Do **not** use `ListTile`, `BottomNavigationBar`, or `SliverWidgets`.
- Design must always:
  - Look premium & elegant
  - Prevent UI overflow
  - Be mobile-first (unless tablet/desktop specified)

---

## 🧪 Loading & Validation
- **Page-level loading**: use boolean + `CircularProgressIndicator`.
- **Button-level loading**: use `EasyLoading.show()` & `dismiss()` appropriately.
- Validation must use `validators` from `core/helpers`.

---

## 🧠 State Management
- Use **BLoC pattern** with `event`, `state`, `bloc`.
- Group bloc files under `presentation/blocs/` and export from `blocs.dart`.

---

## 🔗 Imports
- Always import `package:Xxxx/core/core.dart` in pages.
- Use barrel files (`xxx.dart`) to avoid deep imports.
- If a model or usecase already exists, reuse it — do not redefine.

---

## 📄 Naming Conventions
- Pages: `login_page.dart`, `register_page.dart`, etc.
- Follow naming: `features/feature_name/presentation/pages/xxx_page.dart`
- Related features like login/register/forgot_password share the same page group.
- Use `part of` and `part` for splitting files under one feature.

---

## 🖼️ Misc
- Use [https://placehold.co] for image placeholders if needed.
- Avoid running tests — they may hang in this project.
- If unsure about UI, create multiple sections with premium layout and spacing.

---

## ✅ Example Instruction to Use in Prompt:
> "Create a new `RegisterPage` in the auth feature following my boilerplate structure. Use reusable components from `core/components`, manage state with BLoC, and ensure layout uses Dimens spacing and `.withAlpha` for colors."
