# 🔍 Search Engine Submission Guide

**Air24.app - Sitemap Submission for Bing & Google**

Last Updated: October 9, 2025

---

## 📋 **YOUR SITEMAP URL**

```
https://air24.app/sitemap.xml
```

**What's included:**
- ✅ Homepage (with 6 language variants: EN, ES, PT, FR, DE, PL)
- ✅ Privacy Policy
- ✅ Terms of Service
- ✅ Cookie Policy

---

## 🔷 **BING WEBMASTER TOOLS SUBMISSION**

### **Step 1: Access Bing Webmaster Tools**

1. Go to: **https://www.bing.com/webmasters**
2. Sign in with your Microsoft account
3. You should see `air24.app` already verified ✅

### **Step 2: Submit Sitemap**

1. Click on **`air24.app`** in your dashboard
2. In the left sidebar, click **"Sitemaps"**
3. You'll see a text box that says "Submit a sitemap"
4. Enter: `https://air24.app/sitemap.xml`
5. Click **"Submit"**

### **Step 3: Verify Submission**

After submission, you should see:
- **Status:** "Pending" → Will change to "Success" within 24-48 hours
- **URLs Discovered:** Should show 4 URLs initially
- **Last Crawled:** Will update after first crawl

### **Additional Bing Settings (Recommended)**

**URL Inspection:**
1. Click "URL Inspection" in sidebar
2. Enter: `https://air24.app`
3. Click "Inspect"
4. If not indexed, click **"Request Indexing"**

**Submit Key URLs for Fast Indexing:**
- `https://air24.app/`
- `https://air24.app/privacy`
- `https://air24.app/terms`
- `https://air24.app/cookies`

---

## 🔶 **GOOGLE SEARCH CONSOLE SUBMISSION**

### **Step 1: Access Google Search Console**

1. Go to: **https://search.google.com/search-console**
2. Sign in with your Google account
3. Click **"Add Property"** (or select if already added)

### **Step 2: Add Property (If Not Already Done)**

**Choose method:**

**Option A: Domain Property (Recommended)**
- Enter: `air24.app` (no https://)
- Verify via DNS TXT record

**Option B: URL Prefix**
- Enter: `https://air24.app`
- Verify via HTML file, HTML tag, or Google Analytics

**Verification Methods:**
1. **Google Analytics:** If you have GA installed, use this
2. **HTML Tag:** Add meta tag to `<head>` of index.html
3. **DNS Record:** Add TXT record to your domain DNS

### **Step 3: Submit Sitemap**

1. In Google Search Console dashboard, select **`air24.app`**
2. In the left sidebar, click **"Sitemaps"**
3. Enter in the "Add a new sitemap" field: `sitemap.xml`
4. Click **"Submit"**

### **Step 4: Verify Submission**

After submission, you should see:
- **Status:** "Success" (green checkmark)
- **Discovered URLs:** 4
- **Last read:** Current date/time
- **Type:** Sitemap

### **Step 5: Request Indexing (Fast Track)**

1. Click **"URL Inspection"** in sidebar
2. Enter: `https://air24.app`
3. Click "Test live URL"
4. If not indexed, click **"Request Indexing"**

**Repeat for:**
- `https://air24.app/privacy`
- `https://air24.app/terms`
- `https://air24.app/cookies`

---

## 📊 **MONITORING & TRACKING**

### **Bing Webmaster Tools - What to Check Weekly**

1. **Dashboard → Overview:**
   - Total impressions
   - Total clicks
   - Average CTR
   - Average position

2. **Sitemaps:**
   - URLs submitted vs. indexed
   - Any errors or warnings

3. **SEO Reports → Site Scan:**
   - Check for any issues
   - Fix any warnings

### **Google Search Console - What to Check Weekly**

1. **Performance:**
   - Total clicks
   - Total impressions
   - Average CTR
   - Average position

2. **Coverage:**
   - Valid pages
   - Pages with errors
   - Pages with warnings

3. **Enhancements:**
   - Mobile usability
   - Core Web Vitals

---

## 🚨 **TROUBLESHOOTING**

### **Bing Issues**

**"Sitemap not found"**
- ✅ Check: https://air24.app/sitemap.xml loads in browser
- ✅ Wait 24 hours and resubmit
- ✅ Check robots.txt allows crawling

**"No URLs discovered"**
- ✅ Check XML format is correct
- ✅ Ensure all URLs are absolute (full URLs)
- ✅ Check for XML syntax errors

### **Google Issues**

**"Sitemap could not be read"**
- ✅ Verify sitemap.xml is accessible
- ✅ Check XML syntax
- ✅ Ensure proper encoding (UTF-8)

**"Submitted URL not found (404)"**
- ✅ Verify URLs exist and return 200 status
- ✅ Check Firebase routing
- ✅ Test URLs in incognito browser

---

## 📝 **ROBOTS.TXT**

Make sure your `robots.txt` allows crawling:

```txt
User-agent: *
Allow: /

Sitemap: https://air24.app/sitemap.xml
```

**Check at:** https://air24.app/robots.txt

---

## ✅ **POST-SUBMISSION CHECKLIST**

**Immediate (Day 1):**
- [ ] Sitemap submitted to Bing Webmaster Tools
- [ ] Sitemap submitted to Google Search Console
- [ ] Homepage URL inspection requested (both)
- [ ] Key pages inspection requested (privacy, terms, cookies)

**Week 1:**
- [ ] Check Bing: Sitemap status = "Success"
- [ ] Check Google: Sitemap status = "Success"
- [ ] Check Bing: URLs indexed count
- [ ] Check Google: Coverage report

**Week 2:**
- [ ] Monitor Bing impressions
- [ ] Monitor Google impressions
- [ ] Check for any crawl errors
- [ ] Fix any issues found

**Monthly:**
- [ ] Update sitemap.xml date if content changed
- [ ] Resubmit sitemap if major changes
- [ ] Review performance reports
- [ ] Optimize based on search queries

---

## 🎯 **EXPECTED TIMELINE**

| Event | Bing | Google |
|-------|------|--------|
| **Sitemap processed** | 24-48 hours | 1-2 hours |
| **First crawl** | 2-7 days | 1-3 days |
| **Indexed pages** | 7-14 days | 3-7 days |
| **Appears in search** | 14-30 days | 7-14 days |

---

## 📞 **SUPPORT RESOURCES**

**Bing Webmaster Tools:**
- Help Center: https://www.bing.com/webmasters/help
- Community: https://www.bing.com/webmasters/community

**Google Search Console:**
- Help Center: https://support.google.com/webmasters
- Community: https://support.google.com/webmasters/community

---

## 🔄 **MAINTENANCE SCHEDULE**

**Weekly:**
- Check indexing status
- Review performance metrics
- Monitor for errors

**Monthly:**
- Update sitemap if content changed
- Review top queries
- Optimize meta descriptions

**Quarterly:**
- Full SEO audit
- Update XML sitemap structure
- Review and improve content

---

## 🎉 **QUICK START COMMANDS**

**1. Submit to Bing:**
```
URL: https://www.bing.com/webmasters
Action: Sitemaps → Submit sitemap → https://air24.app/sitemap.xml
```

**2. Submit to Google:**
```
URL: https://search.google.com/search-console
Action: Sitemaps → Add sitemap → sitemap.xml
```

**3. Verify Sitemap Works:**
```
URL: https://air24.app/sitemap.xml
Expected: XML file with 4 URLs
```

---

## ✨ **SUCCESS METRICS**

**After 30 days, you should see:**

**Bing:**
- ✅ 4 URLs indexed
- ✅ 100+ impressions per week
- ✅ Average position < 50

**Google:**
- ✅ 4 URLs indexed
- ✅ 500+ impressions per week
- ✅ Average position < 30

**Both:**
- ✅ CTR > 1%
- ✅ No crawl errors
- ✅ All pages mobile-friendly

---

## 📱 **MOBILE OPTIMIZATION**

Both Bing and Google prioritize mobile-friendly sites:

✅ **Your site is:**
- Responsive design
- Fast loading
- Touch-friendly buttons
- Readable text without zooming

**Test:**
- Google: https://search.google.com/test/mobile-friendly
- Bing: Automatically tested in Webmaster Tools

---

## 🔒 **SECURITY & HTTPS**

✅ **Your site uses HTTPS:** https://air24.app

Both search engines give ranking preference to HTTPS sites.

---

**Good luck with your search engine submissions! 🚀**

You should start seeing results within 2-4 weeks!
