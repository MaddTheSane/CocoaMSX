#ifndef __SHA1_HH__
#define __SHA1_HH__

#include "MsxTypes.h"

#include <string>

#ifdef __APPLE__

#include <CommonCrypto/CommonDigest.h>

class SHA1
{
public:
	SHA1();
	~SHA1();

	/** Update the hash value.
	 */
	void update(const UInt8* data, unsigned len);
	
	/** Get the final hash as a pre-formatted string.
	 * After this method is called, calls to update() are invalid.
	 */
	const std::string& hex_digest();

private:
	void finalize();

	CC_SHA1_CTX ctx;
	std::string digest;
};

#else

class SHA1
{
public:
	SHA1();
	~SHA1();

	/** Update the hash value.
	  */
	void update(const UInt8* data, unsigned len);

	/** Get the final hash as a pre-formatted string.
	  * After this method is called, calls to update() are invalid.
	  */
	const std::string& hex_digest();

private:
	void transform(const UInt8 buffer[64]);
	void finalize();
	
	UInt32 m_state[5];
	UInt64 m_count;
	UInt8  m_buffer[64];

	std::string digest;
};

#endif
#endif
