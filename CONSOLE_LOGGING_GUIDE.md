# 🔍 Console Logging Guide - Reactive Forms

This guide shows you exactly how to see the debounce and validation logging in real-time in Xcode.

## 🚀 How to View Console Logs

### Step 1: Open Xcode and Run the App
1. Open `reactive-forms.xcodeproj` in Xcode
2. Press `⌘+R` to build and run the app in the simulator
3. **Important**: Keep Xcode open and visible

### Step 2: Open the Debug Console
1. In Xcode, go to `View` → `Debug Area` → `Show Debug Area` (or press `⌘+Shift+Y`)
2. Make sure the **Console tab** is selected (bottom pane in Xcode)

### Step 3: Start Using the Form
1. In the simulator, tap **"Start Check-in"** to open the form
2. **Watch the console** - you'll immediately see:

```
🎯 ===== REACTIVE FORMS DEBUG MODE =====
📱 App Started - Console Logging Enabled
🔍 Watch for these events:
   ⌨️  [INPUT] - User typing
   🔄 [DEBOUNCE] - Debounce events
   ⏰ [DEBOUNCE] - Debounce completion
   🌐 [API SIMULATION] - Username availability check
   📧👤💺 [VALIDATION] - Field validation
   💾 [SAVE] - Data persistence
   🎯 [FOCUS] - Focus changes
========================================

🚀 [FORM] PassengerFormView initialized - reactive validation ready!
👁️  [FORM] Form appeared - setting focus to Full Name field
🎯 [FOCUS] Focus changed from none to Full Name
```

## 🎮 Testing Different Scenarios

### 1. **See Debouncing in Action (Username Field)**
- Tap the **Username** field
- Type quickly: `j-a-m-e-s` (don't pause between letters)
- **Watch the console** for:

```
⌨️  [INPUT] Username changed to: 'j'
🔄 [DEBOUNCE] Username input received: 'j'
⌨️  [INPUT] Username changed to: 'ja'
🔄 [DEBOUNCE] Username input received: 'ja'
⌨️  [INPUT] Username changed to: 'jam'
🔄 [DEBOUNCE] Username input received: 'jam'
⌨️  [INPUT] Username changed to: 'jame'
🔄 [DEBOUNCE] Username input received: 'jame'
⌨️  [INPUT] Username changed to: 'james'
🔄 [DEBOUNCE] Username input received: 'james'

# After 400ms of no typing:
⏰ [DEBOUNCE] Debounce completed for: 'james' (400ms passed)
🔍 [VALIDATION] Starting async username check for: 'james'
🌐 [API SIMULATION] Simulating API call for username: 'james'

# After 500ms delay:
❌ [API SIMULATION] Username 'james' is TAKEN
✅ [VALIDATION] Username validation completed: ❌ INVALID: Username taken at Gate M72
```

### 2. **Real-Time Email Validation**
- Tap the **Email** field
- Type: `test` (without @)
- **Watch for instant validation**:

```
🎯 [TEXTFIELD] 'Email' changed from '' to 'test'
⌨️  [INPUT] Username changed to: 'test'
📧 [VALIDATION] Validating email: 'test'
📧 [VALIDATION] Email validation result: ❌ INVALID: Email must contain @
💾 [SAVE] Attempting to save passenger data...
💾 [SAVE] ✅ Passenger data saved successfully
```

### 3. **Auto-Save in Action**
- Fill any field and **watch** for automatic saving:

```
💾 [SAVE] Attempting to save passenger data...
💾 [SAVE] ✅ Passenger data saved successfully
```

### 4. **Focus Management**
- Use the **Return key** to move between fields:

```
🎯 [FOCUS] Focus changed from Full Name to Email
🎯 [FOCUS] Focus changed from Email to Username
🎯 [FOCUS] Focus changed from Username to Seat
```

## 🧪 Best Test Scenarios

### **Scenario 1: Test Debouncing**
1. Go to Username field
2. Type rapidly: `lars` (one of the reserved names)
3. **Observe**: Multiple input events but only one debounce completion after 400ms

### **Scenario 2: Test Async API Simulation**
- Try these usernames to see "taken" status:
  - `james`, `lars`, `kirk`, `robert` (Metallica band members!)
- Try any other username to see "available" status

### **Scenario 3: Test Real-Time Validation**
- Email field: Type `user` (no @) → instant error
- Email field: Type `user@` → instant success
- Full Name: Leave empty, move to next field → required error

## 📱 Console Output Example

When you type in the username field, you'll see something like this in real-time:

```
⌨️  [INPUT] Username changed to: 'k'
🔄 [DEBOUNCE] Username input received: 'k'
⌨️  [INPUT] Username changed to: 'ki'
🔄 [DEBOUNCE] Username input received: 'ki'
⌨️  [INPUT] Username changed to: 'kir'
🔄 [DEBOUNCE] Username input received: 'kir'
⌨️  [INPUT] Username changed to: 'kirk'
🔄 [DEBOUNCE] Username input received: 'kirk'
⏰ [DEBOUNCE] Debounce completed for: 'kirk' (400ms passed)
🔍 [VALIDATION] Starting async username check for: 'kirk'
🌐 [API SIMULATION] Simulating API call for username: 'kirk'
❌ [API SIMULATION] Username 'kirk' is TAKEN
✅ [VALIDATION] Username validation completed: ❌ INVALID: Username taken at Gate M72
💾 [SAVE] Attempting to save passenger data...
💾 [SAVE] ✅ Passenger data saved successfully
```

## 🎯 Key Observations

1. **Debounce Working**: You'll see multiple `[INPUT]` and `[DEBOUNCE]` events but only one `Debounce completed` after 400ms
2. **Async Simulation**: 500ms delay between API start and completion
3. **Real-Time Validation**: Instant feedback for email and required fields
4. **Auto-Save**: Every field change triggers a save operation
5. **Focus Flow**: Smooth keyboard navigation between fields

The console will show you exactly how reactive programming with Combine handles user input, debouncing, async operations, and state management in real-time! 🎉
