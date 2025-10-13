# 🌍 World App Mini App Version

**Branch:** `worldapp-miniapp`

## Purpose

This branch contains the World App Mini App compliant version of AIR24, modified to meet World App's submission requirements.

## Key Differences from Main Branch

### **Authentication Changes**

**Main Branch (web/Play Store/iOS):**
- ✅ Email/Password sign-in
- ✅ Google Sign-In
- ✅ World ID verification

**This Branch (World App Mini App):**
- ❌ Email/Password sign-in (REMOVED)
- ❌ Google Sign-In (REMOVED)
- ✅ **ONLY MiniKit authentication** (per World App requirements)

### **Why These Changes?**

World App reviewers rejected the initial submission with feedback:
> "do not present options for email or google. Only use mini kit. You are using World ID not mini kit."

**Requirements:**
1. Remove all email/Google sign-in options from Mini App version
2. Use MiniKit SDK (not World ID) for authentication
3. Automatic authentication via World App

### **Technical Implementation**

#### **1. Auth Screen Modified**
- Removed email/password fields
- Removed Google Sign-In button
- Removed sign-up/sign-in toggle
- Removed password reset functionality
- **Only** World ID button remains (connected to MiniKit)

#### **2. MiniKit SDK Added**
- Added MiniKit JavaScript SDK via CDN (`index.html`)
- Created `window.MiniKitInterop` bridge for Flutter
- Functions: `isInstalled()`, `walletAuth()`, `getWalletAddress()`

#### **3. User Experience**
- Info card explaining World ID authentication
- Single authentication button: "Sign In with World ID"
- Seamless integration with World App

## File Changes

### Modified Files:
1. **`lib/screens/auth_screen.dart`**
   - Removed email/password UI
   - Removed Google Sign-In button
   - Removed unnecessary toggles
   - Added info card for World ID

2. **`web/index.html`**
   - Added MiniKit SDK import
   - Created MiniKit JavaScript bridge
   - Maintains backward compatibility with IDKit

### New Files:
1. **`WORLDAPP_MINIAPP.md`** (this file)
   - Documentation for this branch

## Development Workflow

### **Working on Main Branch (web/mobile):**
```bash
git checkout main
# Make changes for web/Play Store/iOS
git commit -m "Feature: ..."
git push origin main
```

### **Working on World App Mini App:**
```bash
git checkout worldapp-miniapp
# Make changes for World App submission
git commit -m "MiniApp: ..."
git push origin worldapp-miniapp
```

### **Merging Features from Main:**
If you add features to main that should also be in Mini App:
```bash
git checkout worldapp-miniapp
git merge main
# Resolve conflicts (keep Mini App auth changes)
git push origin worldapp-miniapp
```

## Deployment

### **Main Branch Deployment:**
- Target: `air24.app` (regular web)
- Platforms: Web, iOS, Android, Play Store
- Authentication: Email, Google, World ID

### **World App Branch Deployment:**
- Target: World App Mini App Store
- Platform: World App only
- Authentication: **MiniKit only**

## Resubmission Checklist

- [x] Email/Password sign-in removed
- [x] Google Sign-In removed
- [x] MiniKit SDK integrated
- [x] Auth screen simplified (only World ID button)
- [x] Info card added explaining authentication
- [x] JavaScript bridge created for MiniKit
- [x] Backward compatibility maintained (IDKit still available)
- [ ] Test in World App environment
- [ ] Update submission materials
- [ ] Resubmit to World App team

## Testing

### **Test MiniKit Detection:**
```javascript
// In browser console (when running in World App)
console.log(window.MiniKitInterop.isInstalled()); // Should return true
```

### **Test Authentication:**
1. Open app in World App
2. Should see single "Sign In with World ID" button
3. Click button
4. MiniKit authentication should trigger
5. User authenticated automatically

## Notes

- **Main branch is UNCHANGED** - All existing functionality preserved
- **This branch is ONLY for World App submission**
- **Do not merge this branch back to main** - Keep separate
- **Future World App updates** - Make changes only on this branch

## Changelog for World App Resubmission

```
Version 1.1 - October 2025

WORLD APP COMPLIANCE FIXES:
- Removed email/password sign-in from Mini App version
- Removed Google Sign-In from Mini App version
- Integrated MiniKit SDK for seamless authentication
- Only MiniKit authentication available (per World App requirements)
- Added user-friendly info card explaining World ID sign-in
- Created JavaScript bridge for Flutter-MiniKit communication

TECHNICAL IMPLEMENTATION:
- MiniKit SDK v1.0.0 integrated via CDN
- window.MiniKitInterop bridge created
- Conditional authentication (MiniKit for Mini App)
- Simplified UI for better user experience
- Maintains all core functionality

COMPLIANCE:
- Follows World App Mini App guidelines
- Single authentication method (MiniKit only)
- No external sign-in options
- Ready for World App approval
```

---

**Contact:** contact@air24.app  
**Repository:** https://github.com/PiotrStyla/FlightCompensation  
**Branch:** `worldapp-miniapp`  
**Last Updated:** October 13, 2025
