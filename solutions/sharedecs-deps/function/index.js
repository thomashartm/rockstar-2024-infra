import cf from "cloudfront";
import crypto from "crypto";

const kvsId = '<keyvaluestire-id>';
const aemAuthorUrl = 'author-p34402-e126302.adobeaemcloud.com';
const apiKeyId = "apiKey";
const hmacKeyId = "hmac";

// This fails if the key value store is not associated with the function
const kvsHandle = cf.kvs(kvsId);

function _jwt_decode(token, key, verifySignature, algorithm) {
    const tokenObject = _buildTokenObject(token);

    if (verifySignature) {
        if (
            !_verify(
                tokenObject.signingInput,
                key,
                tokenObject.signingMethod,
                tokenObject.signingType,
                tokenObject.signatureSeg
            )
        ) {
            throw new Error("Signature verification failed");
        }

        const dateNow = Date.now();
        // Support for auth_time and exp claims.
        // According to the RFC, they should be in seconds.

        if (!tokenObject.payload.auth_time ||
            dateNow < tokenObject.payload.auth_time * 1000
        ) {
            throw new Error("Token is inactive");
        }

        if (!tokenObject.payload.exp ||
            dateNow > tokenObject.payload.exp * 1000
        ) {
            throw new Error("Token expired or no expiration is set");
        }

        if (!tokenObject.payload.iss ||
            tokenObject.payload.iss !== aemAuthorUrl
        ) {
            throw new Error("Token issuer is wrong");
        }
    }

    return tokenObject.payload;
}

function _buildTokenObject(token) {
    // check token
    if (!token) {
        throw new Error("No token supplied");
    }
    // check segments
    const segments = token.split(".");
    if (segments.length !== 3) {
        throw new Error("Not enough or too many segments");
    }

    // All segment should be base64
    const headerSeg = segments[0];
    const payloadSeg = segments[1];
    const signatureSeg = segments[2];

    // will return base64 string.
    const signingInput = [headerSeg, payloadSeg].join(".");

    // base64 decode and parse JSON
    const header = JSON.parse(_base64urlDecode(headerSeg));
    const payload = JSON.parse(_base64urlDecode(payloadSeg));

    // signing method and type
    const signingMethod = "sha256";
    const signingType = "hmac";

    return {
        headerSeg,
        payloadSeg,
        signatureSeg,
        header,
        payload,
        signingInput,
        signingMethod,
        signingType,
    };
}


function _verify(input, key, method, type, signature) {
      if (type === "hmac") {
        const calculcated = crypto.createHmac(method, key).update(input).digest("base64url");
        return signature === calculcated;
    } else {
        throw new Error("Algorithm type not recognized");
    }
}

function _base64urlDecode(str) {
    let bufferObj = Buffer.from(str, "base64");
    let decodedString = bufferObj.toString("utf8");
    return decodedString;
}

function _getTokenValue(request) {
    if(request.querystring.token && request.querystring.token.value) {
        return request.querystring.token.value;
    } else {
        return request.cookies.chataem ? request.cookies.chataem.value : '';
    }
}

async function handler(event) {
    const authHeaders = event.request.headers.authorization;
    // nullify the auth header
    event.request.headers['xcdnauth'] = {value: ''};
    const key = event.request.uri.split('/')[1];
    let tokenValue = _getTokenValue(event.request);
    try {

        event.request.headers['chataem'] = {value: tokenValue};


        if(tokenValue.length > 0) {
            const apiKey = await kvsHandle.get(apiKeyId);
            const hmacKey = await kvsHandle.get(hmacKeyId);
            const jwtToken = _jwt_decode(tokenValue, hmacKey, true);

            event.request.headers['xcdnauth'] = {value: apiKey};
            event.request.headers['chataem'] = {value: tokenValue};
            return event.request;
        }
    } catch (err) {
        console.log(`Kvs key lookup failed for ${key}: ${err}`);
    }

    const response = {
        statusCode: 401,
        statusDescription: "Unauthorized",
    };

    return response;
}