package com.quizletgravity.android;

import org.junit.Test;
import static org.junit.Assert.*;

public class NavigationPolicyTest {
    @Test public void acceptsOnlyExactFirstPartyHttpsHosts() {
        assertTrue(NavigationPolicy.isInternal("https://quizzlet-gravity-preview.vercel.app/"));
        assertTrue(NavigationPolicy.isInternal("https://quizzlet-gravity-preview.vercel.app/game?set=123"));
        assertTrue(NavigationPolicy.isInternal("https://QUIZZLET-GRAVITY-PREVIEW.VERCEL.APP:443/"));
        for (String url : new String[]{null, "https://quizzlet-gravity-preview.vercel.app.evil.example/",
                "https://evil.example/quizzlet-gravity-preview.vercel.app", "http://quizzlet-gravity-preview.vercel.app/",
                "https://quizzlet-gravity-preview.vercel.app@evil.example/", "https://evil@quizzlet-gravity-preview.vercel.app/",
                "https://quizzlet-gravity-preview.vercel.app:8443/", "javascript:alert(1)", "file:///etc/passwd",
                "content://private/", "https://quizzlet-gravity-preview.vercel.app\\@evil.example"}) {
            assertFalse("Unexpectedly allowed: " + url, NavigationPolicy.isInternal(url));
        }
    }
    @Test public void externalLinksCannotInvokeArbitraryNativeIntents() {
        assertTrue(NavigationPolicy.isExternal("https://quizlet.com/ch/123/test"));
        assertTrue(NavigationPolicy.isExternal("mailto:hello@example.com"));
        for (String url : new String[]{null, "intent://evil", "javascript:alert(1)",
                "file:///sdcard/private", "data:text/html,hi", "https://user:password@example.com",
                "https:///broken", "mailto:"}) {
            assertFalse(NavigationPolicy.isExternal(url));
        }
    }
}
