/* main.c - main function for markdown module testing */

/*
 * Copyright (c) 2009, Natacha Porté
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

#include "markdown.h"
#include "renderers.h"

#include <stdio.h>
#include <errno.h>
#include <string.h>

#define READ_UNIT 1024
#define OUTPUT_UNIT 64


/* buffer statistics, to track some memleaks */
extern long buffer_stat_nb;
extern size_t buffer_stat_alloc_bytes;



/* main • main function, interfacing STDIO with the parser */
int
main(int argc, char **argv) {
	struct buf *ib, *ob;
	size_t ret;
	FILE *in = stdin;

	/* opening the file if given from the command line */
	if (argc > 1) {
		in = fopen(argv[1], "r");
		if (!in) {
			fprintf(stderr,"Unable to open input file \"%s\": %s\n",
				argv[1], strerror(errno));
			return 1; } }

	/* reading everything */
	ib = bufnew(READ_UNIT);
	bufgrow(ib, READ_UNIT);
	while ((ret = fread(ib->data + ib->size, 1,
			ib->asize - ib->size, in)) > 0) {
		ib->size += ret;
		bufgrow(ib, ib->size + READ_UNIT); }
	if (in != stdin) fclose(in);

	/* performing markdown parsing */
	ob = bufnew(OUTPUT_UNIT);
	markdown(ob, ib, &mkd_xhtml);

	/* writing the result to stdout */
	fwrite(ob->data, 1, ob->size, stdout);

	/* cleanup */
	bufrelease(ib);
	bufrelease(ob);

	/* memory checks */
	if (buffer_stat_nb)
		fprintf(stderr, "Warning: %ld buffers still active\n",
				buffer_stat_nb);
	if (buffer_stat_alloc_bytes)
		fprintf(stderr, "Warning: %zu bytes still allocated\n",
				buffer_stat_alloc_bytes);
	return 0; }

/* vim: set filetype=c: */
