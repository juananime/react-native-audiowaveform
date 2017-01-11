'use strict';

const {PropTypes} = require('React');

const AudioURISourcePropType = PropTypes.shape({
    /**
     * `uri` is a string representing the resource identifier for the image, which
     * could be an http address, a local file path, or the name of a static image
     * resource (which should be wrapped in the `require('./path/to/image.png')`
     * function).
     */
    uri: PropTypes.string,
    /**
     * `bundle` is the iOS asset bundle which the image is included in. This
     * will default to [NSBundle mainBundle] if not set.
     * @platform ios
     */
    bundle: PropTypes.string,
    /**
     * `method` is the HTTP Method to use. Defaults to GET if not specified.
     */
    method: PropTypes.string,
    /**
     * `headers` is an object representing the HTTP headers to send along with the
     * request for a remote image.
     */
    headers: PropTypes.objectOf(PropTypes.string),
    /**
     * `body` is the HTTP body to send with the request. This must be a valid
     * UTF-8 string, and will be sent exactly as specified, with no
     * additional encoding (e.g. URL-escaping or base64) applied.
     */
    body: PropTypes.string,

});

const AudioSourcePropType = PropTypes.oneOfType([
    AudioURISourcePropType,
    // Opaque type returned by require('./image.jpg')
    PropTypes.number,
    // Multiple sources
    PropTypes.arrayOf(AudioURISourcePropType),
]);

module.exports = AudioSourcePropType;
