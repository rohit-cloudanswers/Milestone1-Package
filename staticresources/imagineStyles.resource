* {
    margin: 0;
    padding: 0;
}

html, body, form {
    position: relative;
    height: 100% !important;
}

a, img {
    border: none;
    outline: none;
}
/*body {font-family: Arial, Helvetica, sans-serif;}*/
body {
    font-family: "museo-sans",sans-serif;
}

.fl {
    float: left;
}

.clearfix:after {
    content: ".";
    display: block;
    clear: both;
    visibility: hidden;
    line-height: 0;
    height: 0;
}

.clearfix {
    display: inline-block;
}

html[xmlns] .clearfix {
    display: block;
}

* html .clearfix {
    height: 1%;
}
/* Header Starts */
#header {
    background-color: #fff;
    position: absolute;
    width: 100%;
    z-index: 1;
}

#header {
    position: absolute;
    width: 100%;
    z-index: 11;
}

    #header .header-inner {
        position: relative;
        background-color: #fff;
        width: 84.04%;
        height: 4.05em;
        padding-top: 1.875em;
        max-height: 138px;
        margin: auto;
        z-index: 1;
    }

#logo {
    display: block;
    float: left;
    width: 16.72%;
    height: 85.4%;
    max-width: 200px;
    max-height: 140px;
    background-image: url(http://www.imaginecommunications.com/Imagine/asset/images/logo.png);
    background-size: 90%;
    background-repeat: no-repeat;
    cursor: pointer;
    margin-top: -1em;
    margin-right: 2em;
}

.RTL #logo {
    display: block;
    float: right;
    width: 16.72%;
    height: 85.4%;
    max-width: 125px;
    margin-right: 2em;
    max-height: 100px;
    background-image: url("http://www.imaginecommunications.com/App_Themes/XteraMain/Images/logo-white.png");
    background-size: contain;
    background-repeat: no-repeat;
    cursor: pointer;
}

.image-container {
    position: relative;
    width: 100%;
    background-color: #fff;
}

    .image-container.new-height {
        height: auto !important;
        box-shadow: none;
    }

/* SEARCH BLOCK */
.search-block {
    position: absolute;
    float: right;
    clear: right;
    width: 15%;
    height: 100%;
    right: 0;
    max-height: 17em;
    top: 2.7em !important;
    z-index: 0;
}

.RTL .search-block {
    float: right;
    top: -3.8em !important;
    clear: right;
}

.LTR .search-block .searchBox {
    position: relative;
    width: 100%;
    height: 1.1em;
    max-height: 74px;
    float: right;
    top: -0.75em;
    margin-top: 0.34em;
    border-radius: .41em;
    background-color: #0895d3;
}

.contact-us,
.customer-login {
    color: #0895d3;
    top: -1.3em;
    line-height: 1.55em;
    position: relative;
    font-family: "museo-sans",sans-serif; /*"Myriad Pro", Arial, sans-serif*/
    text-decoration: none;
}

body.contact-us {
    top: auto;
}

.search-block .search-field {
    width: 96%;
    height: 1.1em;
    padding: 0 .57em .2em;
    border: none;
    /*font-style: italic;*/
    position: relative;
    outline: none;
    color: #fff;
    font-size: .8em;
    outline: none;
    vertical-align: middle;
    top: 0.01em;
    background: transparent;
}

    .search-block .search-field::-webkit-input-placeholder {
        color: #fff;
    }
/* SEARCH BLOCK */
/* Footer Starts */
#footer {
    width: 100%;
    height: 4.6875em;
    max-height: 75px;
    background-color: #fff;
    /*margin-top: 1em; Removed by mahadev on 13 march*/
}

    #footer .footer-inner {
        position: relative;
        width: 81.71%;
        margin: auto;
        /*padding-top: 2.5em;*/
        font-size: .6875em;
        color: #0895d3;
        white-space: nowrap;
        text-align: center;
        padding: 1.5em;
    }

/*.footer-inner .copyrights {float: left;vertical-align: middle; margin-top:.3em; color:#0895d3; font-size:1.4em; font-weight:normal}*/
.footer-inner .copyrights {
    float: left;
    vertical-align: middle;
    margin-top: .17em;
    color: #0895d3;
    font-size: 1.4em;
    font-weight: normal;
}

.RTL .footer-inner .copyrights {
    float: right;
    vertical-align: middle;
}

.bottom-nav {
    display: inline-block;
    vertical-align: middle;
    padding: 0 2em;
    margin-left: -22em;
    margin-top: 0.6em;
}

.RTL .bottom-nav {
    display: inline-block;
    vertical-align: middle;
    padding: 0 2em;
    margin-left: 7em;
    border-left: solid 1px #fff;
    font-size: 1.4em;
}

.bottom-nav li {
    float: left;
    padding-left: 1.5em;
    font-size: 1.4em;
    position: relative;
    margin-top: -.4em;
    list-style: none;
}

    .bottom-nav li span {
        font-size: 1.6em;
        color: #a8a8a8;
        padding-right: .5em;
    }

.RTL .bottom-nav li {
    float: right;
    padding-left: 1.5em;
    font-size: 1.4em;
    margin-top: 1em;
    list-style: none;
}

    .RTL .bottom-nav li span {
        font-size: 1.6em;
        color: #a8a8a8;
        padding-right: .5em;
    }

.bottom-nav li:first-child {
    padding-left: 0;
}

.RTL .bottom-nav li:first-child {
    padding-left: 10px;
}


.footer-inner .social-links {
    position: absolute;
    right: 0;
    top: 1.5em;
    vertical-align: middle;
}

.RTL .footer-inner .social-links {
    position: absolute;
    left: 0;
    top: 2.5em;
    right: auto;
    vertical-align: middle;
}

.footer-inner .social-links ul {
    overflow: hidden;
    margin-right: 24px;
    margin-top: 0.6em;
}

.footer-inner .social-links li {
    float: left;
    margin-left: .58em;
    list-style: none;
    width: 1.67em;
    height: 1.67em;
}

    .footer-inner .social-links li:first-child {
        margin-left: 0;
    }

.footer-inner .social-links a {
    display: block;
    width: 1.67em;
    height: 1.67em;
    background-repeat: no-repeat;
    background-size: contain;
    color: transparent;
}

.social-links li.twitter a {
    background-image: url(http://www.imaginecommunications.com/Imagine/asset/images/social-media.png);
}

.social-links li.rss a {
    background-image: url(http://www.imaginecommunications.com/Imagine/asset/images/rss.png);
}

.social-links li.youtube a {
    background-image: url(http://www.imaginecommunications.com/Imagine/asset/images/you-tube.png);
}

.social-links li.linkedin a {
    background-image: url(http://www.imaginecommunications.com/Imagine/asset/images/link-ind.png);
}



.image-container#home {
    height: 90.23%;
}
/* TAB PANNEL STARTS */
.homepage-block-container {
    position: absolute;
    bottom: 0;
    margin: 0 auto;
    z-index: 4;
    width: 67.70%;
    left: 17.10%;
}

.market-page {
    position: absolute;
    bottom: 2.04em;
    bottom: 1.52em\9;
    margin: 0 auto;
    z-index: 4;
    width: 68.70%;
    left: 11%;
}

.homepage-block-container.solu {
    width: 63.03%;
    left: 10.985%;
}

.homepage-block-container .color-block,
.homepage-block-container .product-block,
.market-page .solutions-box {
    position: relative;
}
/*.market-page .solutions-box div.tab-img-txt span.tab-img {display:block}
.market-page .solutions-box div+span.tab-img {display:none; border:1px solid red}
*/
.homepage-block-container .color-block,
.homepage-block-container .product-block {
    position: absolute;
    bottom: 0;
    width: 17.9%;
    height: auto;
    padding: 0 .5em;
    list-style: none;
    float: left;
    margin: 0;
    background: #231f20;
    opacity: .95;
    color: #fff;
}

    .homepage-block-container .color-block:hover,
    .homepage-block-container .product-block:hover { /*box-shadow: 1px 2px .625em #231f20*/
    }

    .homepage-block-container .color-block.create-block,
    .homepage-block-container .product-block.create-block {
        left: 0;
        background: #243d80;
    }

        .homepage-block-container .color-block.create-block .block-text {
            background: url(http://www.imaginecommunications.com/Imagine/asset/images/bot-tab-first.png) center bottom no-repeat;
            padding-bottom: 100px;
            background-size: contain !important;
        }

        .homepage-block-container .product-block.create-block .tab-box {
            background: url(http://www.imaginecommunications.com/Imagine/asset/images/media.png) center bottom no-repeat;
            padding-bottom: 100px;
            background-size: contain !important;
        }



    .homepage-block-container .color-block.optimize-block,
    .homepage-block-container .product-block.optimize-block {
        left: 20.1%;
        background-color: #0668b2;
    }

.homepage-block-container.solu .color-block.optimize-block {
    left: 20.5%;
    background-color: #0668b2;
}

.homepage-block-container .color-block.optimize-block .block-text {
    background: url(http://www.imaginecommunications.com/Imagine/asset/images/bot-tab-2nd.png) center bottom no-repeat;
    padding-bottom: 100px;
    background-size: contain !important;
}

.homepage-block-container .product-block.optimize-block .tab-box {
    background: url(http://www.imaginecommunications.com/Imagine/asset/images/playout.png) center bottom no-repeat;
    padding-bottom: 100px;
    background-size: contain !important;
}

.homepage-block-container .color-block.play-block {
    left: 39.8%;
    background-color: #8ebace;
}

.homepage-block-container.solu .color-block.play-block {
    left: 41%;
    background-color: #8EBACE;
}

.homepage-block-container .product-block.play-block {
    left: 20.3%;
    background-color: #8ebace;
}

.homepage-block-container .color-block.play-block .block-text {
    background: url(http://www.imaginecommunications.com/Imagine/asset/images/bot-tab-3rd.png) center bottom no-repeat;
    padding-bottom: 100px;
    background-size: contain !important;
}

.homepage-block-container .product-block.play-block .tab-box {
    background: url(http://www.imaginecommunications.com/Imagine/asset/images/networking.png) center bottom no-repeat;
    padding-bottom: 100px;
    background-size: contain !important;
}

.homepage-block-container .color-block.deliver-block {
    left: 59.5%;
    background-color: #a8a8a8;
}

.homepage-block-container.solu .color-block.deliver-block {
    left: 61.5%;
    background-color: #A8A8A8;
}

.homepage-block-container .color-block.deliver-block .block-text {
    background: url(http://www.imaginecommunications.com/Imagine/asset/images/bot-tab-4th.png) center bottom no-repeat;
    padding-bottom: 100px;
    background-size: contain !important;
}


.homepage-block-container .color-block.innovative-block {
    left: 79.2%;
    background-color: #26a9e0;
}

    .homepage-block-container .color-block.innovative-block .block-text {
        background: url(http://www.imaginecommunications.com/Imagine/asset/images/bot-tab-5th.png) center bottom no-repeat;
        padding-bottom: 100px;
        background-size: contain !important;
    }

.homepage-block-container .color-block a,
.homepage-block-container .product-block a {
    text-decoration: none;
    color: inherit;
    transition: color 700ms;
    -webkit-transition: color 700ms;
    -moz-transition: color 700ms;
    -ms-transition: color 700ms;
    -o-transition: color 700ms;
}

    .homepage-block-container .color-block a:hover,
    .homepage-block-container .product-block a:hover {
        color: #fff;
    }

    .homepage-block-container .color-block a:active {
        color: #fff;
    }

    .homepage-block-container .product-block a:hover {
        color: #fff;
    }

.homepage-block-container .color-block .block-title,
.homepage-block-container .product-block .block-title {
    display: block;
    width: auto;
    line-height: 1.8em;
    font-size: 1.3em;
    /*amol cahnge for homepage*/
    font-weight: 300;
    /*amol cahnge for homepage*/
    vertical-align: middle;
    white-space: nowrap;
}

.homepage-block-container .product-block.play-block .block-title {
    line-height: 1.3em;
}

.EditMode .homepage-block-container .color-block .block-title,
.EditMode .homepage-block-container .product-block .block-title {
    line-height: normal;
}

.homepage-block-container .color-block .block-text {
    display: none;
    padding: 1em 0 2.1875em 0;
    border-top: solid 1px #e6e7e8;
}

.homepage-block-container .product-block .tab-box {
    padding: 1em 0 2.1875em 0;
    border-top: solid 1px #e6e7e8;
}

.EditMode .homepage-block-container .color-block .block-text,
.EditMode .homepage-block-container .product-block .tab-box {
    display: block;
}


.homepage-block-container .color-block .block-text,
.homepage-block-container .product-block .tab-box {
    font-size: .875em;
    padding-bottom: 1em;
}

.homepage-block-container .color-block .block-text,
.homepage-block-container .product-block .tab-box {
    font-size: .6875em;
}

.homepage-block-container .color-block:first-child,
.homepage-block-container .product-block:first-child {
    margin-left: 0;
}

.tab-img img {
    display: none;
}

.tab-img-txt {
    display: none;
}

.tab-box ul {
    margin: 10px 0 0;
    padding: 0;
}

    .tab-box ul li {
        float: none;
        list-style: none;
        line-height: 18px;
    }

        .tab-box ul li span span {
            margin-right: 5px;
        }

.tab-box-news {
    display: none;
}

.market-page .solutions-box {
    position: absolute;
    bottom: 0;
    width: 17.6%;
    height: auto;
    padding: 0 !important;
    margin: 0 !important;
    opacity: .95;
    color: #fff;
    min-height: 17em;
    /*box-shadow: 1px 2px .625em #231f20*/
}

    .market-page .solutions-box .tab-img-txt {
        width: 86%;
        margin: 0 auto !important;
        display: block;
        padding: .4em 0 0 0;
    }

        .market-page .solutions-box .tab-img-txt a {
            text-decoration: none !important;
            font-size: 1.3em;
        }

        .market-page .solutions-box .tab-img-txt .title {
            display: block !important;
            color: #fff;
            line-height: 1.8em;
            text-decoration: none;
            font-weight: normal;
            padding-bottom: 0.5em;
            margin-bottom: 0 !important;
            vertical-align: middle;
            white-space: normal;
            word-wrap: break-word;
        }


.market-page div + div {
    left: 18% !important;
}

    .market-page div + div + div {
        left: 36% !important;
    }

        .market-page div + div + div + div {
            left: 54% !important;
        }

            .market-page div + div + div + div + div {
                left: 72% !important;
            }

                .market-page div + div + div + div + div + div {
                    left: 90% !important;
                }

.market-page div.solutions-box {
    background-color: #233d7f;
}

.market-page div + div.solutions-box {
    background-color: #0967b2;
}

.market-page div + div + div.solutions-box {
    background-color: #467ebb;
}

.market-page div + div + div + div.solutions-box {
    background-color: #6eb2d2;
}

.market-page div + div + div + div + div.solutions-box {
    background-color: #8fbace;
}

.market-page div + div + div + div + div + div.solutions-box {
    background-color: #a8a8a8;
}

.market-page div + div.solutions-box .tab-img-txt .title {
    line-height: 1.2em;
}

.market-page div + div + div.solutions-box .tab-img-txt .title {
    line-height: 1.2em;
}

.market-page div + div + div + div.solutions-box .tab-img-txt .title {
    line-height: 1.2em;
}

.market-page .solutions-box .tab-img-last {
    border-top: .10em solid #fff;
    margin-left: 7%;
    margin-right: 7%;
    width: 86% !important;
}

    .market-page .solutions-box .tab-img-last img {
        display: block !important;
        margin: 1.8em 0 1em !important;
        width: 100% !important;
    }

.tab-img-last {
    width: 100%;
}

.tab-img-last {
    display: none;
}

/*span.tab-img span+span{display:none;}
span.tab-img:hover span.content{
	border-top:.10em solid #fff !important;
	font-size:.6em;
	color:#fff; 
	display:block
	}*/
.solutions-box span.tab-img span + span {
    /*display: none;*/
    display: block;
}

.solutions-box:hover span.tab-img span.content {
    border-top: .10em solid #fff !important;
    font-size: .6em;
    color: #fff;
    display: block;
}


.market-page div + div {
    left: 18% !important;
}

    .market-page div + div + div {
        left: 36% !important;
    }

        .market-page div + div + div + div {
            left: 54% !important;
        }

            .market-page div + div + div + div + div {
                left: 72% !important;
            }

                .market-page div + div + div + div + div + div {
                    left: 90% !important;
                }

.tab-img-txt {
    margin: 0 !important;
}

.market-page .solutions-box .tab-img-txt a {
    text-decoration: none !important;
    font-size: 1.2em !important;
}

.market-page div.solutions-box .tab-img-txt .title {
    text-decoration: none !important;
    font-size: 1.0em !important;
    padding: 0 !important;
}

.market-page div.solutions-box .tab-img-txt .title {
    line-height: 1.3em !important;
}

.market-page div + div.solutions-box .tab-img-txt .title {
    /*line-height: 1.8em !important;*/
}

.market-page div + div + div.solutions-box .tab-img-txt .title {
    line-height: 1.3em !important;
}

.market-page .solutions-box .tab-img-last {
    border-top: none !important;
    margin-left: 7%;
    margin-right: 7%;
    width: 86% !important;
}

.market-page div.solutions-box {
    background-color: #233d7f;
}

.market-page div + div.solutions-box {
    background-color: #0967b2;
}

.market-page div + div + div.solutions-box {
    background-color: #8fbace;
}

.market-page div + div + div + div.solutions-box {
    background-color: #a8a8a8;
}
/*.market-page div+div+div+div.solutions-box .tab-img-txt .title{line-height:1.3em !important}*/

.market-page div + div {
    left: 18% !important;
}

    .market-page div + div + div {
        left: 36% !important;
    }

        .market-page div + div + div + div {
            left: 54% !important;
        }

            .market-page div + div + div + div + div {
                left: 72% !important;
            }

                .market-page div + div + div + div + div + div {
                    left: 90% !important;
                }

.market-page div.solutions-box {
    background-color: #233d7f;
}

.market-page div + div.solutions-box {
    background-color: #0967b2;
}

.market-page div + div + div.solutions-box {
    background-color: #467ebb;
}

.market-page div + div + div + div.solutions-box {
    background-color: #6eb2d2;
}

.market-page div + div + div + div + div.solutions-box {
    background-color: #8fbace;
}

.market-page div + div + div + div + div + div.solutions-box {
    background-color: #a8a8a8;
}

.market-page div + div.solutions-box .tab-img-txt .title {
    line-height: 1.2em;
}

.market-page div + div + div.solutions-box .tab-img-txt .title {
    line-height: 1.2em;
}

.market-page div + div + div + div.solutions-box .tab-img-txt .title {
    line-height: 1.2em;
}

.market-page .solutions-box .tab-img-last {
    border-top: .10em solid #fff;
    margin-left: 7%;
    margin-right: 7%;
    width: 86% !important;
}

    .market-page .solutions-box .tab-img-last img {
        display: block !important;
        margin: 1.8em 0 1em !important;
        width: 100% !important;
        height: 11em;
    }

.tab-img-last {
    width: 100%;
}

.tab-img-last {
    display: none;
}

span.tab-img span + span {
    display: none;
}

span.tab-img:hover span.content {
    border-top: .10em solid #fff !important;
    font-size: .6em;
    color: #fff;
    display: block;
}

/* SLIDE SHOW STARTS */
.slideshow-controls-container {
    position: absolute;
    width: 100%;
    right: -5.1%;
    bottom: 8%;
}

.slideshow-controls {
    width: 57%;
    margin: auto;
    text-align: right;
}

    .slideshow-controls ul {
        float: right;
    }

    .slideshow-controls li {
        float: left;
        width: .85em;
        height: .85em;
        margin-left: .63em;
        list-style: none;
        cursor: pointer;
        border-radius: .625em;
        background-color: #ffffff;
    }

        .slideshow-controls li.current {
            background-color: #0895d3;
        }

.slides-frame {
    position: absolute;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    overflow: hidden;
}

.slides {
    position: absolute;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    margin-left: 0;
}

    .slides .slide {
        position: absolute;
        top: 0;
        left: 0;
        display: none;
        width: 100%;
        height: 100%;
    }

        .slides .slide img {
            position: absolute;
            top: 6.5em !important;
            left: 0;
            width: 100%;
            height: 100%;
        }

        .slides .slide .img-src {
            display: none;
        }

        .slides .slide.initial {
            display: block;
        }

.slide-content {
    position: relative;
    width: 84.01%;
    height: 100%;
    margin: auto;
}

    .slide-content hgroup {
        position: absolute;
        left: 0;
        top: 55.91%;
    }

    .slide-content h1 {
        font-size: 4.5em;
        font-weight: 200;
        white-space: nowrap;
        text-shadow: 2px 2px 4px #000;
    }

    .slide-content h2 {
        font-size: 2.5em;
        font-weight: 200;
        line-height: 1.2em;
    }

.slide {
    background-size: cover;
    background-position: center center;
    color: #fff;
}

.image-container#internal {
    height: 26.04%;
    max-height: 200px;
    box-shadow: 0 0 1.25em #999;
    overflow: hidden;
    background-color: #fff;
}

    .image-container#internal img {
        position: absolute;
        top: 0;
        left: 0;
    }

.content-wrap {
    height: auto;
    min-height: 60%;
    padding-top: 1.5625em;
    background-color: #fff;
}

#content {
    width: 78.03%;
    margin: auto;
    padding-bottom: 2.8125em;
    overflow: hidden;
}

    #content .page-title h1 {
        padding: .2em 0 .5em;
        clear: both;
        font-size: 2.25em;
        color: #243c7e;
        font-weight: normal;
        text-transform: uppercase;
        word-spacing: .25em;
    }
        /*#content .page-title h1.fs-3{font-size: 3.8em; text-transform:inherit; }*/
        #content .page-title h1.fs-3 {
            font-size: 3.8em !important;
            text-transform: inherit;
            padding: 0.2em 0 0em;
        }

.product-category {
    border: .10em solid #0d95d3;
    padding: 0 .55em;
    height: 2.7em;
    line-height: 2.7em;
    float: left;
    width: 20.7em;
    color: #a8a8a8;
    margin: 1.4em 0 0 0;
    font-size: 1em;
    display: none;
}

    .product-category a {
        color: #a8a8a8;
        text-decoration: none;
        padding: 0 .75em;
    }

        .product-category a.active, .product-category a:focus {
            color: #0d95d3;
        }

.w50per {
    width: 50%;
}


/* pagination */
.border-bot {
    border-bottom: .10em solid #27a9e1;
    padding: 0 0 .5em 0;
    width: 80% !important;
}

ul.alphabets {
    border-top: 1px solid #0D95D3;
    color: #0D95D3;
    margin: .45em 0 .8em 0;
    padding: .45em 0 0 0;
}

    ul.alphabets li {
        float: left;
        list-style: none;
    }

        ul.alphabets li a {
            font-size: 1.2em;
            color: #a8a8a8;
            padding: 0 .55em;
            text-decoration: none;
        }

        ul.alphabets li:first-child a {
            padding-left: 0;
            color: #0d95d3;
            text-decoration: underline;
        }

        ul.alphabets li:hover a, ul.alphabets li.active a {
            color: #0d95d3;
        }

.index-list {
    margin: .45em 0 0 0;
    height: 16.25em !important;
    width: 100%;
    overflow-y: auto;
    overflow-x: hidden;
}

    .index-list .list {
    }

        .index-list .list .alpha {
            display: none;
        }

        .index-list .list ul {
            margin: 0;
            padding: 0;
            display: block;
            width: 100% !important;
            clear: left;
        }

            .index-list .list ul li {
                float: left;
                list-style: none;
                color: #a8a8a8;
                display: inline;
                font-size: .82em;
                line-height: 1.7em;
                margin: 0 .2em 0 0;
            }

                .index-list .list ul li:before {
                    content: ', ';
                }

                .index-list .list ul li:first-child:before {
                    content: '';
                }

                .index-list .list ul li a {
                    color: #a8a8a8;
                    text-decoration: none;
                }

                .index-list .list ul li:hover a, .index-list .list ul li:focus a, .index-list .list ul li.active a {
                    color: #0d95d3;
                    text-decoration: none;
                }

.box1 {
    position: absolute;
    width: 16.4em;
    right: 0%;
    height: 10em;
    top: 9em;
    padding: 1em 0 .8em 1em !important;
    background: -moz-linear-gradient(top, rgba(255,255,255,0.9) 0%, rgba(255,255,255,0.9) 100%);
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(255,255,255,0.9)), color-stop(100%,rgba(255,255,255,0.9)));
    background: -webkit-linear-gradient(top, rgba(255,255,255,0.9) 0%,rgba(255,255,255,0.9) 100%);
    background: -o-linear-gradient(top, rgba(255,255,255,0.9) 0%,rgba(255,255,255,0.9) 100%);
    background: -ms-linear-gradient(top, rgba(255,255,255,0.9) 0%,rgba(255,255,255,0.9) 100%);
    background: linear-gradient(to bottom, rgba(255,255,255,0.9) 0%,rgba(255,255,255,0.9) 100%);
    filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#ccffffff', endColorstr='#ccffffff',GradientType=0 );
    box-shadow: .5em .5em .65em #000;
}

.slides .slide .box1 img {
    height: 100% !important;
    width: 100% !important;
    position: relative !important;
    top: 0px !important;
}

.box1 .text-area {
    color: #0895d3;
    font-size: .8em;
    line-height: 1.1em;
    width: 85%;
    margin: .3em 0 0 0;
}

    .box1 .text-area a {
        color: #0895d3;
        text-decoration: none;
    }

.box1 .pink-div {
    display: none;
}

.box1:hover .pink-div {
    display: block;
    height: 100%;
    width: 100%;
    top: 0;
    left: 0;
    position: absolute;
    background: -moz-linear-gradient(top, rgba(144,39,142,0.5) 0%, rgba(144,39,142,0.5) 100%);
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(144,39,142,0.5)), color-stop(100%,rgba(144,39,142,0.5)));
    background: -webkit-linear-gradient(top, rgba(144,39,142,0.5) 0%,rgba(144,39,142,0.5) 100%);
    background: -o-linear-gradient(top, rgba(144,39,142,0.5) 0%,rgba(144,39,142,0.5) 100%);
    background: -ms-linear-gradient(top, rgba(144,39,142,0.5) 0%,rgba(144,39,142,0.5) 100%);
    background: linear-gradient(to bottom, rgba(144,39,142,0.5) 0%,rgba(144,39,142,0.5) 100%);
    filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#8090278e', endColorstr='#8090278e',GradientType=0 );
    line-height: 10.5em;
    text-align: center;
}

    .box1:hover .pink-div a {
        color: #fff;
        font-size: 1.12em;
        text-decoration: none;
    }

.box2 {
    position: absolute;
    width: 9.7em;
    height: 9em;
    right: 0;
    top: 23em;
    padding: 1em 1em .7em 0px !important;
    background: -moz-linear-gradient(top, rgba(255,255,255,0.9) 0%, rgba(255,255,255,0.9) 100%);
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(255,255,255,0.9)), color-stop(100%,rgba(255,255,255,0.9)));
    background: -webkit-linear-gradient(top, rgba(255,255,255,0.9) 0%,rgba(255,255,255,0.9) 100%);
    background: -o-linear-gradient(top, rgba(255,255,255,0.9) 0%,rgba(255,255,255,0.9) 100%);
    background: -ms-linear-gradient(top, rgba(255,255,255,0.9) 0%,rgba(255,255,255,0.9) 100%);
    background: linear-gradient(to bottom, rgba(255,255,255,0.9) 0%,rgba(255,255,255,0.9) 100%);
    filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#ccffffff', endColorstr='#ccffffff',GradientType=0 );
    box-shadow: .5em .5em .65em #000;
    overflow: hidden;
}

.slides .slide .box2 img {
    height: 100% !important;
    width: 100% !important;
    position: relative !important;
    top: 0 !important;
}

.box2 .text-area {
    color: #0895d3;
    font-size: .8em;
    line-height: 1em;
    width: 90%;
    margin: 3px 0 0 10%;
}

    .box2 .text-area a {
        color: #0895d3;
    }

.box2 .pink-div {
    display: none;
}

.box2:hover .pink-div {
    display: block;
    height: 100%;
    width: 100%;
    top: 0;
    left: 0;
    position: absolute;
    background: -moz-linear-gradient(top, rgba(144,39,142,0.5) 0%, rgba(144,39,142,0.5) 100%);
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(144,39,142,0.5)), color-stop(100%,rgba(144,39,142,0.5)));
    background: -webkit-linear-gradient(top, rgba(144,39,142,0.5) 0%,rgba(144,39,142,0.5) 100%);
    background: -o-linear-gradient(top, rgba(144,39,142,0.5) 0%,rgba(144,39,142,0.5) 100%);
    background: -ms-linear-gradient(top, rgba(144,39,142,0.5) 0%,rgba(144,39,142,0.5) 100%);
    background: linear-gradient(to bottom, rgba(144,39,142,0.5) 0%,rgba(144,39,142,0.5) 100%);
    filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#8090278e', endColorstr='#8090278e',GradientType=0 );
    line-height: 10.5em;
    text-align: center;
}

    .box2:hover .pink-div a {
        color: #fff;
        font-size: 1.12em;
        text-decoration: none;
    }

/* Bread Crumb Starts */
.LTR .top-links .breadcrumbs {
    width: 77.5%;
    margin: 0 auto;
    padding: 8em 0 1em;
    font-size: 1em;
    color: #233d7f;
    font-weight: bold;
}

.RTL .top-links .breadcrumbs {
    float: right;
    width: 70%;
    color: #233d7f;
}

.top-links .breadcrumbs a {
    position: relative;
    padding: 0 0 0 .45em;
    color: #233d7f;
    text-decoration: none;
    font-size: 1em; /*1.2em;*/
    text-transform: capitalize;
}

    .top-links .breadcrumbs a:first-child {
        padding: 0 0 0 0px;
    }

    .top-links .breadcrumbs a.CMSBreadCrumbsCurrentItem {
        color: #cb2027;
    }

.LTR .top-links .breadcrumbs > *:last-child {
    color: #27a9e1;
}

.LTR .top-links .breadcrumbs .interText {
    color: #FFFFFF;
}

.top-links .breadcrumbs .CMSBreadCrumbsCurrentItem {
    color: #27a9e1;
}

.RTL .top-links .breadcrumbs > *:first-child {
    color: #cb2027;
}

.LTR .top-links .breadcrumbs > *:first-child {
    padding-left: 0;
}

.LTR .breadcrumbs .home {
    float: left;
}

.breadcrumbs .home:after {
    content: ">";
    padding: 0 .2em;
    display: block;
    display: inline-block;
}

.RTL .breadcrumbs .home {
    float: right;
}

.content-pannel {
    width: 77.5%;
    margin: 0 auto;
    padding: 1em 0;
}

.para-text {
    width: 53em;
    font-size: .98em;
    color: #27a9e1;
    line-height: 1.3em;
}

.channel-block {
    margin: 10px 0 0 0;
}

    .channel-block p {
        display: none;
    }

    .channel-block img {
        display: none;
    }

    .channel-block a.full-box {
        margin: 0;
        padding: 0;
        display: block;
    }

/*stw changes*/
.zoneMainContent {
    width: 100%;
    height: 100%;
}

.homepage-block-container .color-block {
    /*amol cahnges for home page*/
    /*font-size: 100% !important;*/
}


/*.nav.top > ul {
    height: auto;
    margin: 30px 0 0;
    min-height: 27px;
    position: relative;
}*/
.nav ul li ul li ul {
    display: block !important;
    visibility: visible !important;
    height: auto !important;
}
/* Prashant changes */
/*.nav ul li ul li
{
	max-width: 200px;
}*/
/* Prashant changes */
.nav ul li ul li.parent {
    float: left;
    /* Prashant changes */
    width: 13.01em;
    background: none !important;
}

.nav > ul > li > ul {
    max-width: 100%;
    /* Change By Prashant - start */
    overflow: visible;
    /* Change By Prashant - end */
    /*width: 100%;*/
}

.nav ul li ul {
    left: auto;
    padding-top: 0;
    top: 100%;
}

.nav > ul > li > ul > li {
    /*background: -moz-linear-gradient(top,  rgba(60,178,227,0.7) 0%, rgba(60,178,227,0.7) 100%);
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(60,178,227,0.7)), color-stop(100%,rgba(60,178,227,0.7)));
	background: -webkit-linear-gradient(top,  rgba(60,178,227,0.7) 0%,rgba(60,178,227,0.7) 100%);
	background: -o-linear-gradient(top,  rgba(60,178,227,0.7) 0%,rgba(60,178,227,0.7) 100%);
	background: -ms-linear-gradient(top,  rgba(60,178,227,0.7) 0%,rgba(60,178,227,0.7) 100%);
	background: linear-gradient(to bottom,  rgba(60,178,227,0.7) 0%,rgba(60,178,227,0.7) 100%);
	filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#b33cb2e3', endColorstr='#b33cb2e3',GradientType=0 );*/
    /* Change By Prashant - start */
    /*background: transparent url(http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png) 0 0 repeat;*/
    /* Change By Prashant - end */
}

.nav ul li ul li.parent.parentul {
    /*background: -moz-linear-gradient(top,  rgba(60,178,227,0.7) 0%, rgba(60,178,227,0.7) 100%) !important;
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(60,178,227,0.7)), color-stop(100%,rgba(60,178,227,0.7))) !important;
	background: -webkit-linear-gradient(top,  rgba(60,178,227,0.7) 0%,rgba(60,178,227,0.7) 100%) !important;
	background: -o-linear-gradient(top,  rgba(60,178,227,0.7) 0%,rgba(60,178,227,0.7) 100%) !important;
	background: -ms-linear-gradient(top,  rgba(60,178,227,0.7) 0%,rgba(60,178,227,0.7) 100%) !important;
	background: linear-gradient(to bottom,  rgba(60,178,227,0.7) 0%,rgba(60,178,227,0.7) 100%) !important;
	filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#b33cb2e3', endColorstr='#b33cb2e3',GradientType=0 ) !important;*/
    /* Change By Prashant - start */
    /*background: transparent url(http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png) 0 0 repeat;*/
    /* Change By Prashant - end */
    display: block;
    height: 100% !important;
    position: relative;
}

    .nav ul li ul li.parent.parentul > a, .nav ul li ul li.parent.parentul > span {
        font-size: 0.9em;
        position: relative;
        z-index: 10;
    }

    .nav ul li ul li.parent.parentul > span {
        padding: 0 0 0 0.5em;
        display: block;
    }

.clsDesc p {
    width: 53em;
    font-size: .98em;
    color: #27a9e1;
    line-height: 1.3em;
}
/*end stw changes*/

@media screen and (-webkit-min-device-pixel-ratio:0) {
    .nav ul li a {
        position: relative;
        top: -.1em;
    }

    .slideshow-controls li {
        margin-left: .62em;
    }

    .LTR .nav.top {
        top: 0.5em;
    }

    /* Safari only override */
    ::i-block-chrome, .slides .slide .box1 img {
        height: 2.8em !important;
    }

    ::i-block-chrome, .slides .slide .box2 img {
        height: 2.8em !important;
    }

    ::i-block-chrome, .slideshow-controls li {
        margin-left: .74em;
    }

    ::i-block-chrome, .LTR .nav.top {
        top: .6em;
        margin-top: 2.10em;
    }

    ::i-block-chrome, .nav ul li a {
        position: relative;
        top: -.3em;
    }

    ::i-block-chrome, .nav ul li ul.third-menu {
        max-width: 11em;
        min-width: 11em;
        width: 11em;
    }

    ::i-block-chrome, .nav ul li ul.first-menu li.bg {
        top: -0em;
    }

    ::i-block-chrome, .nav ul li ul.second-menu li.bg {
        left: 0em;
        top: .5em;
    }

    ::i-block-chrome, .nav ul li ul.third-menu li.bg {
        left: -1em;
        top: -1.6em;
    }

    ::i-block-chrome, .nav ul li ul.fourth-menu li.bg {
        left: -1em;
        top: -2.0em;
    }

    ::i-block-chrome, .nav ul li ul.media-content li.bg {
        left: 0em;
        top: -6.23em;
    }

    ::i-block-chrome, .nav ul li ul.network-infra li.bg {
        left: 0em;
        top: -2.48em;
    }

    ::i-block-chrome, .search-block .search-field {
        top: -.4em;
    }
}
/* Mozila hack */
@-moz-document url-prefix() {
    .nav ul li ul.first-menu li.bg;

{
    top: -.42em;
}

.nav ul li ul.second-menu li.bg {
    left: 0em;
    top: -.38em;
}

.nav ul li ul.third-menu li.bg {
    left: -1em;
    top: -2.3em;
}

.nav ul li ul.fourth-menu li.bg {
    left: -1em;
    top: -2.8em;
}

.nav ul li ul.media-content li.bg {
    left: 0em;
    top: -7.23em;
}

.nav ul li ul.network-infra li.bg {
    left: 0em;
    top: -2.13em;
}

.LTR .nav.top {
    top: .5em;
}

}

.ie11 .LTR .nav.top {
    top: 0.4em;
}

.ie10 .nav ul li a {
    position: relative;
    top: 0.3em;
    font-weight: 300 !important;
}

.ie11 .nav ul li a {
    position: relative;
    top: 0.3em;
    font-weight: 300 !important;
}

.ie11 .nav ul li ul.first-menu li.bg {
    top: -.42em;
}

.ie11 .nav ul li ul.second-menu li.bg {
    left: 0em;
    top: -.08em;
}

.ie11 .nav ul li ul.third-menu li.bg {
    left: -1em;
    top: -2.3em;
}

.ie11 .nav ul li ul.fourth-menu li.bg {
    left: -1em;
    top: -2.8em;
}

.ie11 .nav ul li ul.media-content li.bg {
    left: 0em;
    top: -7.23em;
}

.ie11 .nav ul li ul.network-infra li.bg {
    left: 0em;
    top: -2.13em;
}
/*.homepage-block-container .product-block.play-block {left: 20.2%;background-color:#8ebace; }*/


.allContents {
    list-style: none outside none;
    max-width: 62em;
}

    .allContents .tab-box {
        color: #ACACAB;
        display: block;
        margin: 0 0 2em !important;
        overflow: hidden;
    }

        .allContents .tab-box:hover {
            /*opacity: 0.5;*/ /*commentted for hiding on /products/networking-infrastructure.aspx  link */
        }

    .allContents .tab-img
    /*background: none repeat scroll 0 0 #92278F;*/ {
        /*float: left;*/
        height: 6em;
        margin: 0 1em 0 0;
        width: 10em;
        overflow: hidden;
    }

    .allContents .tab-box .tab-link {
        color: #253D7F;
        float: right;
        font-weight: normal;
        margin: 0;
        max-width: 35em;
        padding: 0 0 0.2em;
    }

        .allContents .tab-box .tab-link span {
            font-size: 1.6em;
            line-height: 1em;
        }

            .allContents .tab-box .tab-link span > br {
                display: none;
            }

html {
    overflow-y: inherit !important;
}

a {
    text-decoration: none;
}

.allContents .tab-img img {
    display: block !important;
    height: 100%;
    margin: 0;
    padding: 0;
    width: 100%;
}

.allContents .channel-block p {
    color: #ACACAB;
    display: block !important;
    font-size: 1.2em;
    width: 27.2em;
}


/*.products .allContents .channel-block p
{
	width: 27.2em !important;
}*/
.products .allContents .channel-block .solutionContent p, .products .allContents .channel-block .solutionContent > .tab-box { /* for this  /products/networking-infrastructure.aspx*/
    width: 75%;
}

.products .allContents .tab-box .tab-link span {
    font-size: 1.3em;
    line-height: 1em;
}

.products .allContents .solutionContent .tab-box .tab-link {
    font-size: 0.8em;
}

.products .allContents .channel-block div.solutionContent {
    border-bottom: 0.11em solid #6D6F71;
    margin-bottom: 1em;
    min-height: 7em;
}

.products .allContents .tab-img {
    width: 22%;
}

    .products .allContents .tab-img img {
        width: 100%;
        height: 100px;
    }

.products .allContents .channel-block div.solutionContent:hover {
    opacity: 0.5;
}
/*stw_kiran css*/
ul, li {
    list-style: none;
}

html {
    overflow-y: inherit !important;
}

.search-block {
    top: 1.7em !important;
}

.subpage {
    background: #F4F4F5;
    padding: 6em 0 0;
}
/* Done By Prashant */
.LTR .nav.top {
}

.banner {
    height: 11em;
    /* Change by Prashant starts */
    margin: -2.78em 0 1.5em;
    /* Change by Prashant ends */
    position: relative;
    width: 100%;
}

    .banner .top-links .breadcrumbs {
        font-size: 0.8em;
    }

        .banner .top-links .breadcrumbs a, .banner .breadcrumbs .home:after {
            color: #FFF;
        }
/* Change By Prashant - start */
.solutions .banner {
    background: none repeat scroll 0 0 #253D7F !important;
}

.solutions .nav.top > ul > li.active {
    color: #fff;
    background: transparent url(http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png) 0 0 repeat;
}

    .solutions .nav.top > ul > li.active a {
        color: #fff;
    }

.solutions .nav.top > ul > li:hover,
/* Changes done by prashant starts */
.solutions .nav.top > ul > li.active
/* Changes done by prashant starts */ {
    background: transparent url(http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png) 0 0 repeat;
}
/* Change By Prashant - ends */
.nav.top > ul > li.active > a {
    /* Change By Prashant - start */
    color: #0895D3;
    /* Change By Prashant - end */
}

.banner h1 {
    color: #FFFFFF;
    font-size: 3.5em;
    font-weight: normal;
    line-height: 1em;
    margin: 0 auto;
    padding: 0;
    width: 77.5%;
    padding-top: 0.7em;
}

.banner > img {
    bottom: 0;
    position: absolute;
    right: 30%;
}

.leftpane {
    float: left;
    font-size: 1.3em;
    width: 75%;
}

    .leftpane > p {
        margin: 0 2em 1em 0;
        color: #253d7f;
    }

.subnav {
    float: right;
    font-size: 0.9em;
    list-style: none outside none;
    position: relative;
    text-align: right;
    width: 20%;
}

    .subnav li {
        line-height: 1.4em;
        list-style: none outside none;
    }

    .subnav a {
        text-decoration: none;
    }

    .subnav a {
        text-decoration: none;
    }

        .subnav a:hover {
            font-weight: bold;
        }

    .subnav > ul li > a {
        color: #489fd7;
        text-transform: uppercase;
    }

#menuElem > li > a {
    color: #489fd7;
    text-transform: uppercase;
}

li.HighLighted > a {
    color: #489fd7;
    text-transform: uppercase;
}

.subnav > ul li > ul {
    display: none;
    padding: 0 0 0.5em;
    height: auto;
}

li.HighLighted > ul, li.highlighted > ul {
    display: block !important;
    padding: 0 0 0.5em;
    height: auto;
}

.subnav > ul li > ul a {
    color: #555557;
}

.create .product-category {
    font-size: 1.4em;
    left: 17em;
    margin: 8em 0 0;
    padding: 0 1.01em;
}

.leftpane h2, .leftpane.fortabs h1 {
    color: #253D7F;
    font-size: 1.6em;
    font-weight: normal;
    line-height: 1em;
    margin: 0 0 1em;
    /*text-transform: uppercase;*/
    text-transform: capitalize;
}

.leftpane h2 {
    font-size: 1.7em;
}

.portfolio {
    list-style: none outside none;
    max-width: 62em;
}

    .portfolio li {
        overflow: hidden;
        color: #acacab;
        padding: 0 0 2em;
    }

        .portfolio li:hover {
            opacity: 0.5;
        }

.forimg {
    /*background: none repeat scroll 0 0 #92278F;*/
    float: left;
    height: 6em;
    margin: 0 1em 0 0;
    width: 10em;
}

.portfolio li h3 {
    color: #253D7F;
    font-size: 1.6em;
    font-weight: normal;
    line-height: 1em;
    margin: 0;
    padding: 0 0 0.2em;
}

.subfooter {
    height: 1.688em !important;
    background: none repeat scroll 0 0 #F4F4F5 !important;
}

    .subfooter .footer-inner {
        padding-top: 0.5em !important;
    }

        .subfooter .footer-inner .bottom-nav li span {
            font-size: 1em;
        }

        .subfooter .footer-inner .copyrights {
            margin: 0;
        }

        .subfooter .footer-inner .social-links {
            top: 0;
        }
/* Change By Prashant - start */
.products .banner {
    background: none repeat scroll 0 0 #1568b3;
}

.products .nav.top > ul > li.active {
    background: transparent url(http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png) repeat;
}

.products .nav.top > ul > li:hover,
.products .LTR .nav ul li ul li ul,
.products .nav ul li ul li ul,
.products .nav > ul > li > ul > li {
    background-color: transparent;
}

.products .nav ul li ul {
    background-color: transparent;
}
/* Change By Prashant - end */
.learn-box {
    background: none repeat scroll 0 0 #1796D3;
    color: #FFFFFF;
    max-width: 62em;
    overflow: hidden;
}

    .learn-box h2 {
        background: none repeat scroll 0 0 #F4F4F5;
        font-size: 2em;
        font-weight: normal;
        line-height: 1.7em;
        color: #1796d3;
        text-transform: capitalize;
        margin: 0 0 0.3em;
    }

    .learn-box > div {
        float: left;
        padding: 2%;
        width: 46%;
    }

    .learn-box h3 {
        font-size: 1.5em;
        font-weight: normal;
        line-height: 1.7em;
    }

    .learn-box ul {
        margin: 0 0 1em;
        overflow: hidden;
        list-style: none;
    }

        .learn-box ul li:before {
            color: #000000;
            display: inline-block;
            padding: 0 0.2em;
        }

        .learn-box ul li a, .learn-box ul li strong > span {
            background: url(http://www.imaginecommunications.com/Imagine/asset/images/icon-a1.jpg) left top no-repeat;
            color: #FFFFFF;
            line-height: 0.7em;
            padding: 0 0 0 1.5em;
            text-decoration: none;
        }

            .learn-box ul li a:hover, .learn-box ul li strong > span:hover {
                background: url(http://www.imaginecommunications.com/Imagine/asset/images/icon-a-hover.jpg) left top no-repeat;
            }


/*.learn-box ul li .info-text:hover
        {
            background-position: left bottom;
            font-weight: bold !important;
            font-size: 1em;
        }*/
/* Changes Done by Prashant Ends*/
.enterprise .banner {
    background: none repeat scroll 0 0 #a9a9a9;
}

.enterprise .nav.top > ul > li.active {
    background: transparent url(http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png) repeat;
}

.enterprise .nav.top > ul > li:hover, .enterprise .LTR .nav ul li ul li ul, .enterprise .nav ul li ul li ul, .enterprise .nav > ul > li > ul > li {
    background-color: transparent !important;
}
/* Changes Done by Prashant Ends */
.thmlist {
    list-style: none outside none;
    overflow: hidden;
}

    .thmlist li {
        color: #253D7F;
        font-size: 0.8em;
        margin: 0 0 1em;
        overflow: hidden;
    }

        .thmlist li .forimg {
            height: 20em;
            width: 48%;
        }

        .thmlist li:nth-child(even) .forimg {
            float: right;
            margin: 0 0 0 1em;
        }

        .thmlist li:nth-child(even) p {
            text-align: right;
        }

/*.leftpane > h3
{
    color: #253D7F;
    font-size: 1.7em;
    font-weight: normal;
    line-height: 1em;
    margin: 0 0 0.2em;
}*/
.bottompane > h3 {
    color: #253D7F;
    font-size: 1.7em;
    font-weight: normal;
    line-height: 1em;
    margin: 0 0 0.2em;
    margin: -0.6em 0 0.7em !important;
    background: none repeat scroll 0 0 #FFFFFF;
}

.sol-box {
    background: none repeat scroll 0 0 #A9A9A9;
    /* Prashant changes */
    color: #FFFFFF;
    overflow: hidden;
    padding: 1em 0;
}

.awards .leftpane {
    padding-right: 1em;
}

.sol-box li {
    float: left;
    margin: 0 0 0.9em 2.3%;
    position: relative;
    width: 22%;
}

.awards .sol-box li {
    height: 11em;
    padding: 1%;
    width: 20%;
}

    .awards .sol-box li:hover {
        opacity: 1;
    }

.sol-box li a {
    color: #FFFFFF;
    display: block;
    font-size: 1.7em;
    line-height: 1em;
    padding: 0.4em 0 0;
    text-decoration: none;
}

.sol-box .imgsol {
    /* Prashant changes */
    /*background: none repeat scroll 0 0 #91278F;*/
    border: 1em solid #FFFFFF;
    height: 8em;
    width: 8em;
}

.awards .sol-box .imgsol {
    border: none;
}

.sol-box .imgsol img {
    width: 4.65em;
    height: 4.65em;
}

.blu-div {
    background: url(http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png) left top repeat;
    height: 10em;
    left: 0;
    position: absolute;
    top: 0;
    display: none;
    width: 100%;
}

.awards .blu-div {
    height: 12em;
    left: 0;
    top: 0;
    width: 100%;
}


.sol-box li:hover a {
    color: #0c95d3;
}

.awards .sol-box li a:hover .blu-div {
    display: block;
}

.awards .sol-box li:hover > .blu-div {
    display: none;
}
/* New Css 3 March 2014 */
.subnav > li > ul .active a, .subnav > .active > a {
    font-weight: bold;
}

#menuElem > li > ul > li > a {
    /*  text-transform: lowercase;*/
    text-transform: capitalize;
    color: #555557;
}

#menuElem > li > ul > li.HighLighted a {
    /*  text-transform: lowercase;*/
    text-transform: capitalize;
    font-weight: bold;
}

a {
    text-decoration: none;
}
/* Changes By Prashant Starts */
.technical-support .banner {
    background: none repeat scroll 0 0 #253d7f;
}

.technical-support .nav.top > ul > li.active {
    background: transparent url(http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png) repeat;
}

.technical-support .nav.top > ul > li:hover, .technical-support .LTR .nav ul li ul li ul, .technical-support .nav ul li ul li ul, .technical-support .nav > ul > li > ul > li {
    background-color: transparent;
}
/* Changes By Prashant Ends */
.page-nav {
    overflow: hidden;
    position: relative;
    margin: 0 0 2em;
}

    .page-nav li {
        font-size: 1.5em;
        color: #253d7f;
        line-height: 1.3em;
    }

        .page-nav li:before {
            content: ">";
            display: inline-block;
            padding: 0 0 0 0.2em;
        }

        .page-nav li a {
            color: #253d7f;
        }

        .page-nav li:hover, .page-nav li:hover a {
            font-weight: bold;
        }

.addres-box {
    backface-visibility: #a9a9a9;
}

.addres-box {
    background: none repeat scroll 0 0 #A9A9A9;
    color: #FFFFFF;
    font-size: 0.9em;
    line-height: 1.4em;
    margin: 0 0 1em;
    overflow: hidden;
    padding: 0.5em 1em;
}

    .addres-box > p {
        font-style: italic;
    }

    .addres-box ul li {
        overflow: hidden;
        padding: 0 0 1.5em;
    }

        .addres-box ul li div {
            float: left;
            width: 50%;
        }

        .addres-box ul li span, .addres-box ul li a {
            color: #0c95d3;
        }

/* Changed By Prashant Starts */
.training .banner {
    background: #0668b3;
}

.training .nav.top > ul > li.active {
    background: transparent url(http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png) repeat;
}

.training .nav.top > ul > li:hover,
.training .LTR .nav ul li ul li ul, .training .nav ul li ul li ul, .training .nav > ul > li > ul > li {
    background-color: transparent;
}
/* Changed By Prashant Ends */
.page-text {
    background: none repeat scroll 0 0 #A9A9A9;
    color: #FFFFFF;
    font-size: 0.9em;
    line-height: 1.4em;
    margin: 0 0 1em;
    overflow: hidden;
    padding: 0.5em 1em;
}

    .page-text p {
        margin: 0 0 1em;
    }

    .page-text h4 {
        color: #0c95d3;
        font-size: 1.2em;
        font-weight: normal;
        line-height: 1em;
        margin: 0 0 1em;
    }

    .page-text a {
        color: #0c95d3;
    }
/* Changes by Prashant starts*/
.professional-services .banner {
    background: #8fbace;
}

.professional-services .nav.top > ul > li.active {
    background: transparent url(http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png) repeat;
}

.professional-services .nav.top > ul > li:hover, .professional-services .nav ul li ul li ul, .professional-services .nav > ul > li > ul > li {
    background-color: transparent;
}

.agreements .banner {
    background: #243f81;
}

.agreements .nav.top > ul > li.active {
    background: transparent url(http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png) repeat;
}

.agreements .nav.top > ul > li:hover, .agreements .LTR .nav ul li ul li ul {
    background-color: transparent;
}

.warranties .banner {
    background: #243e80;
}

.warranties .nav.top > ul > li.active {
    background: transparent url(http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png) repeat;
}

.warranties .nav.top > ul > li:hover, .warranties .LTR .nav ul li ul li ul {
    background-color: transparent;
}
/* Changes by Prashant Ends*/
.subPagesBody #home.image-container {
    height: auto !important;
}

.subpage .top-links .breadcrumbs {
    margin: 0 auto;
    padding: 1em 0;
    position: relative;
    z-index: 10;
    font-weight: bold;
}

    .subpage .top-links .breadcrumbs a, .subpage .breadcrumbs .home:after {
        color: #FFFFFF;
    }

.allContents .tab-img img {
    display: block !important;
    margin: 0;
    max-width: 100%;
    padding: 0;
}

/*.content-page p
{
    background: none repeat scroll 0 0 #A9A9A9;
    /*color: #FFFFFF;
    font-size: 0.9em;
    line-height: 1.4em;
    overflow: hidden;
    padding: 0.5em 1em;
}*/
/* Changes Done by Prashant Starts */
.services .banner {
    background: #243f81;
}

.services .nav.top > ul > li.active {
    background: transparent url(http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png) repeat;
}

.services .nav.top > ul > li:hover, .services .LTR .nav ul li ul li ul, .services .nav ul li ul li ul,
.services .nav > ul > li > ul > li {
    background-color: transparent;
}
/* Changes Done By Prashant Ends */
.solutionContent {
    margin: 0 0 2em;
    overflow: hidden;
}

.solutions .allContents .channel-block div.solutionContent {
    border-bottom: 0.11em solid #6D6F71;
}

.solutionContent .full-box {
    display: block;
    float: right;
    margin: 0 !important;
    max-width: 35em;
    padding: 0;
    width: 35em;
}

.allContents .channel-block .solutionContent p {
    color: #ACACAB;
    display: block !important;
    float: right;
    font-size: 1.2em;
    width: 27.2em;
}

    .allContents .channel-block .solutionContent p .tab-box.full-box {
        float: none;
        margin: 0 !important;
        max-width: 100%;
        width: auto;
    }

.solutions .allContents .channel-block .solutionContent p .tab-box.full-box {
    margin: 0 0 2em !important;
}

.create .allContents .tab-box .tab-link span {
    font-size: 1.3em;
}

.create .solutionContent > a {
    margin: 0 !important;
    padding: 0 0 0.2em !important;
}

.create .solutionContent p > a, .create .allContents .channel-block .solutionContent p .tab-box.full-box {
    margin: 0 !important;
}

.create .solutionContent {
    margin-bottom: 1em;
    min-height: 7em;
}

    .create .solutionContent .tab-box .tab-link {
        font-size: 0.8em;
    }

.create .allContents .channel-block .solutionContent > .tab-box {
    width: 34.5em;
}

.create .allContents .channel-block .solutionContent p {
    width: 28.7em;
}

@media screen and (-webkit-min-device-pixel-ratio:0) {
    /* Safari and Chrome, if Chrome rule needed */
    .create .allContents .channel-block .solutionContent > .tab-box {
        width: 33em;
    }

    .create .allContents .channel-block .solutionContent p {
        width: 27.4em;
    }
}

.create .solutionContent:hover {
    opacity: 0.5;
}

.portfolio li:hover {
    opacity: 0.5;
}

.create .headerImage > img {
    bottom: -1.6em;
    height: 10.5em !important;
    left: auto !important;
    position: absolute;
    right: 0;
    top: auto !important;
    width: 21em;
}


.portfolio li:hover {
    opacity: 0.5;
}

.forimg {
    /*background: none repeat scroll 0 0 #92278F;*/
    float: left;
    height: 6em;
    margin: 0 1em 0 0;
    width: 10em;
}

.portfolio li h3 {
    color: #253D7F;
    font-size: 1.6em;
    font-weight: normal;
    line-height: 1em;
    margin: 0;
    padding: 0 0 0.2em;
}

.subfooter {
    height: 1.688em !important;
    background: none repeat scroll 0 0 #F4F4F5 !important;
}

    .subfooter .footer-inner {
        padding-top: 0.5em !important;
    }

        .subfooter .footer-inner .bottom-nav li span {
            font-size: 1em;
        }

        .subfooter .footer-inner .copyrights {
            margin: 0;
        }

        .subfooter .footer-inner .social-links {
            top: 0;
        }
/* Code Change By Prashant Starts */
/*.products .banner, .products .nav.top > ul > li.active, .products .nav.top > ul > li:hover, .products .LTR .nav ul li ul li ul, .products .nav ul li ul li ul,
.products .nav > ul > li > ul > li
{
	background: none repeat scroll 0 0 #1568b3;
}
*/
/* Code Change By Prashant Starts */
.learn-box {
    background: none repeat scroll 0 0 #1796D3;
    color: #FFFFFF;
    max-width: 62em;
    overflow: hidden;
}

    .learn-box h2 {
        background: none repeat scroll 0 0 #F4F4F5;
        font-size: 2em;
        font-weight: normal;
        line-height: 1.7em;
        color: #1796d3;
        text-transform: capitalize;
        margin: 0 0 0.3em;
    }

    .learn-box > div {
        float: left;
        padding: 2%;
        width: 46%;
    }

    .learn-box h3 {
        font-size: 1.5em;
        font-weight: normal;
        line-height: 1.7em;
    }

    .learn-box ul {
        margin: 0 0 1em;
        overflow: hidden;
        list-style: none;
    }

        .learn-box ul li:before {
            color: #000000;
            display: inline-block;
            padding: 0 0.2em;
        }

    .learn-box .data li:hover a, .learn-box .data li:hover em {
        color: #FFFFFF;
    }

    .learn-box .col {
        float: left;
        width: 50%;
    }

        .learn-box .col .data {
            padding: 1em;
        }
/*.learn-box ul li .info-text:hover
        {
            background-position: left bottom;
            font-weight: bold !important;
            font-size: 1em;
        }*/
.products .learn-box .data li span {
    color: #FFFFFF;
}
/* Change Done by Prashant Starts*/
/*.enterprise .banner, .enterprise .nav.top > ul > li.active, .enterprise .nav.top > ul > li:hover, .enterprise .LTR .nav ul li ul li ul, .enterprise .nav ul li ul li ul, .enterprise .nav > ul > li > ul > li
{
	background: none repeat scroll 0 0 #a9a9a9;
}
*/
/* Change Done by Prashant  Ends*/
.thmlist {
    list-style: none outside none;
    overflow: hidden;
}

    .thmlist li {
        color: #253D7F;
        font-size: 0.8em;
        margin: 0 0 1em;
        overflow: hidden;
    }

        .thmlist li .forimg {
            height: 20em;
            width: 48%;
        }

        .thmlist li:nth-child(even) .forimg {
            float: right;
            margin: 0 0 0 1em;
        }

        .thmlist li:nth-child(even) p {
            text-align: right;
        }

.leftpane > h3, .solution-dtsl > h3 {
    color: #253D7F;
    font-size: 1.7em;
    font-weight: normal;
    line-height: 1em;
    margin: 0 0 0.2em;
}

.sol-box {
    background: none repeat scroll 0 0 #A9A9A9;
    color: #CCCCBC;
    overflow: hidden;
    padding: 1em 0;
}

.awards .leftpane {
    padding-right: 1em;
}

.sol-box li {
    float: left;
    margin: 0 0 0.9em 2.3%;
    position: relative;
    width: 22%;
}

.awards .sol-box li {
    height: 11em;
    padding: 1%;
    width: 20%;
}

    .awards .sol-box li:hover {
        opacity: 1;
    }

.sol-box li a {
    color: #FFFFFF;
    display: block;
    /*amol cahnges*/
    font-size: 1.6em;
    /*amol cahnges*/
    line-height: 1em;
    padding: 0.4em 0 0;
    text-decoration: none;
}

.sol-box .imgsol {
    /*background: none repeat scroll 0 0 #91278F !important;*/
    border: 1em solid #FFFFFF;
    height: 8em;
    width: 8em;
}

.awards .sol-box .imgsol {
    border: medium none;
    height: auto;
    width: auto;
}

.awards .sol-box .imgsol {
    background: none repeat scroll 0 0 #FFFFFF !important;
}

.sol-box .imgsol img {
    width: 4.65em;
    height: 4.65em;
}

.blu-div {
    background: url(http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png) left top repeat;
    height: 10em;
    left: 0;
    position: absolute;
    top: 0;
    display: none;
    width: 10em;
}

.awards .blu-div {
    height: 12em;
    left: 0;
    top: 0;
    width: 100%;
}


.sol-box li:hover a {
    color: #0c95d3;
}

.awards .sol-box li a:hover .blu-div {
    display: block;
}

.awards .sol-box li:hover > .blu-div {
    display: none;
}
/* New Css 3 March 2014 */
.subnav > li > ul .active a, .subnav > .active > a {
    font-weight: bold;
}

#menuElem > li > ul > li > a {
    /*  text-transform: lowercase;*/
    text-transform: capitalize;
    color: #555557;
}

#menuElem > li > ul > li.HighLighted a {
    /*  text-transform: lowercase;*/
    text-transform: capitalize;
    font-weight: bold;
}

a {
    text-decoration: none;
}
/* Change done by prashant Starts */
.technical-support .banner {
    background: none repeat scroll 0 0 #253d7f;
}

.technical-support .nav.top > ul > li.active {
    background: transparent url(http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png) repeat;
}

.technical-support .nav.top > ul > li:hover, .technical-support .LTR .nav ul li ul li ul,
.technical-support .nav ul li ul li ul, .technical-support .nav > ul > li > ul > li {
    background-color: transparent;
}
/* Change done by prashant Starts */
.page-nav {
    overflow: hidden;
    position: relative;
    margin: 0 0 2em;
}

    .page-nav li {
        font-size: 1.5em;
        color: #253d7f;
        line-height: 1.3em;
    }

        .page-nav li:before {
            content: ">";
            display: inline-block;
            padding: 0 0 0 0.2em;
        }

        .page-nav li a {
            color: #253d7f;
        }

        .page-nav li:hover, .page-nav li:hover a {
            font-weight: bold;
        }

.addres-box {
    backface-visibility: #a9a9a9;
}

.addres-box {
    background: none repeat scroll 0 0 #A9A9A9;
    color: #FFFFFF;
    font-size: 0.9em;
    line-height: 1.4em;
    margin: 0 0 1em;
    overflow: hidden;
    padding: 0.5em 1em;
}

    .addres-box > p {
        font-style: italic;
    }

    .addres-box ul li {
        overflow: hidden;
        padding: 0 0 1.5em;
    }

        .addres-box ul li div {
            float: left;
            width: 50%;
        }

        .addres-box ul li span, .addres-box ul li a {
            color: #0c95d3;
        }

/*.training .banner, .training .nav.top > ul > li.active, .training .nav.top > ul > li:hover,
.training .LTR .nav ul li ul li ul, .training .nav ul li ul li ul, .training .nav > ul > li > ul > li
{
	background: #0668b3;
}
*/
.page-text {
    background: none repeat scroll 0 0 #A9A9A9;
    color: #FFFFFF;
    font-size: 0.9em;
    line-height: 1.4em;
    margin: 0 0 1em;
    overflow: hidden;
    padding: 0.5em 1em;
}

    .page-text p {
        margin: 0 0 1em;
    }

    .page-text h4 {
        color: #0c95d3;
        font-size: 1.2em;
        font-weight: normal;
        line-height: 1em;
        margin: 0 0 1em;
    }

    .page-text a {
        color: #0c95d3;
    }
/* Changes By Prashant Starts */
.professional-services .banner {
    background: #8fbace;
}

.professional-services .nav.top > ul > li.active {
    background: transparent url(http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png) repeat;
}

.professional-services .nav.top > ul > li:hover, .professional-services .nav ul li ul li ul,
.professional-services .nav > ul > li > ul > li {
    background-color: transparent;
}

.agreements .banner {
    background: #243f81;
}

.agreements .nav.top > ul > li.active {
    background: transparent url(http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png) repeat;
}

.agreements .nav.top > ul > li:hover, .agreements .LTR .nav ul li ul li ul {
    background-color: transparent;
}
/* Changes By Prashant Ends */
.warranties .banner {
    background: #243e80;
}

.warranties .nav.top > ul > li.active {
    background: transparent url(http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png) repeat;
}

.warranties .nav.top > ul > li:hover, .warranties .LTR .nav ul li ul li ul {
    background-color: transparent;
}
/* Changes By Prashant Ends */
.subPagesBody #home.image-container {
    height: auto !important;
}

.subpage .top-links .breadcrumbs {
    margin: 0 auto;
    padding: 1em 0;
    position: relative;
    z-index: 10;
    font-weight: bold;
}

    .subpage .top-links .breadcrumbs a, .subpage .breadcrumbs .home:after {
        color: #FFFFFF;
    }

.allContents .tab-img img {
    display: block !important;
    margin: 0;
    max-width: 100%;
    padding: 0;
}

/*.content-page p
{
    background: none repeat scroll 0 0 #A9A9A9;
    /*color: #FFFFFF;
    font-size: 0.9em;
    line-height: 1.4em;
    overflow: hidden;
    padding: 0.5em 1em;
}*/

/*.services .banner, .services .nav.top > ul > li.active, .services .nav.top > ul > li:hover, .services .LTR .nav ul li ul li ul, .services .nav ul li ul li ul,
.services .nav > ul > li > ul > li
{
	background: #243f81;
}
*/
.solutionContent {
    margin: 0 0 2em;
    overflow: hidden;
}

.solutions .allContents .channel-block div.solutionContent {
    border-bottom: 0.11em solid #6D6F71;
}

.solutions .allContents .channel-block .solutionContent p .tab-box.full-box {
    margin: 0 0 2em !important;
}

.create .allContents .tab-box .tab-link span {
    font-size: 1.3em;
}

.create .solutionContent > a {
    margin: 0 !important;
    padding: 0 0 0.2em !important;
}

.create .solutionContent p > a, .create .allContents .channel-block .solutionContent p .tab-box.full-box {
    margin: 0 !important;
}

.create .solutionContent {
    margin-bottom: 1em;
    min-height: 7em;
}

    .create .solutionContent .tab-box .tab-link {
        font-size: 0.8em;
    }

.create .allContents .channel-block .solutionContent > .tab-box {
    width: 34.5em;
}

.create .allContents .channel-block .solutionContent p {
    width: 28.7em;
}

@media screen and (-webkit-min-device-pixel-ratio:0) {
    /* Safari and Chrome, if Chrome rule needed */
    .create .allContents .channel-block .solutionContent > .tab-box {
        width: 33em;
    }

    .create .allContents .channel-block .solutionContent p {
        width: 27.4em;
    }
}

.create .solutionContent:hover {
    opacity: 0.5;
}

.create .headerImage > img {
    bottom: -3.3em; /*-1.6em;*/
    height: 11em !important; /*10.5em;*/
    left: auto !important;
    position: absolute;
    right: 0;
    top: auto !important;
    width: 26%!important;
}

.create .headerImage {
    position: relative;
}

.deliver .allContents .tab-box .tab-link span {
    font-size: 1.3em;
}

.deliver .solutionContent > a {
    margin: 0 !important;
    padding: 0 0 0.2em !important;
}

.deliver .solutionContent p > a, .deliver .allContents .channel-block .solutionContent p .tab-box.full-box {
    margin: 0 !important;
}

.deliver .solutionContent {
    margin-bottom: 1em;
    min-height: 7em;
}

    .deliver .solutionContent .tab-box .tab-link {
        font-size: 0.8em;
    }

.deliver .allContents .channel-block .solutionContent > .tab-box {
    width: 77%;
}

.deliver .allContents .channel-block .solutionContent p {
    width: 77%;
}

@media screen and (-webkit-min-device-pixel-ratio:0) {
    /* Safari and Chrome, if Chrome rule needed */
    .deliver .allContents .channel-block .solutionContent > .tab-box {
        width: 33em;
    }

    .deliver .allContents .channel-block .solutionContent p {
        width: 27.4em;
    }
}

.deliver .solutionContent:hover {
    opacity: 0.5;
}

.deliver .headerImage > img {
    bottom: -3.3em; /*-1.6em;*/
    height: 11em !important; /*10.5em;*/
    left: auto !important;
    position: absolute;
    right: 0;
    top: auto !important;
    width: 26%!important;
}

.deliver .headerImage {
    position: relative;
}

.play .allContents .tab-box .tab-link span {
    font-size: 1.3em;
}

.play .allContents .channel-block p {
    /* font-size: 0.9em;*/
    width: auto;
}

.play .allContents .tab-box {
    margin: 0 0 1em !important;
    padding-bottom: 0.3em!important;
    /* border-bottom: 0.11em solid #6D6F71;*/
}

    .play .allContents .tab-box:hover {
        opacity: 0.5;
    }

.play .headerImage > img {
    /*bottom: -1.6em;
    height: 10.5em;*/
    bottom: -3.3em; /*-1.6em;*/
    height: 11em!important; /*10.5em;*/
    left: auto !important;
    position: absolute;
    right: 0;
    top: auto !important;
    width: 26%!important;
}

@media screen and (-webkit-min-device-pixel-ratio:0) {
    /* Safari and Chrome, if Chrome rule needed */
    .play .allContents .tab-box .tab-link {
        max-width: 33em;
    }
}

.play .headerImage {
    position: relative;
}

.optimize .allContents .tab-box .tab-link span {
    font-size: 1.3em;
}

.optimize .allContents .channel-block p {
    /* font-size: 0.9em;*/
    width: auto;
}

.optimize .allContents .tab-box {
    margin: 0 0 1em !important;
    padding-bottom: 0.3em!important;
    /*border-bottom: 0.11em solid #6D6F71;*/
}

    .optimize .allContents .tab-box:hover {
        opacity: 0.5;
    }

.optimize .headerImage > img {
    /*bottom: -1.6em;
    height: 10.5em;*/
    bottom: -3.3em; /*-1.6em;*/
    height: 11em!important; /*10.5em;*/
    left: auto !important;
    position: absolute;
    right: 0;
    top: auto !important;
    width: 26%!important;
}

@media screen and (-webkit-min-device-pixel-ratio:0) {
    /* Safari and Chrome, if Chrome rule needed */
    .optimize .allContents .tab-box .tab-link {
        max-width: 33em;
    }
}

.optimize .headerImage {
    position: relative;
}

.allContents .channel-block .solutionContent > .tab-box {
    float: right;
    margin: 0 !important;
    width: 33em;
}

.allContents .solutionContent .tab-box .tab-link {
    float: left;
}

.allContents .channel-block .solutionContent p span {
    color: #ACACAB;
}

.allContents a.tab-box.full-box > img, .allContents .tab-box.sm-box > img {
    height: 6em !important;
    width: 10em !important;
}

.products .allContents a.tab-box {
    /*border-bottom: 0.11em solid #6D6F71;
    padding-bottom: 0;*/
}

.channel-block a.full-box {
    width: auto;
}

.professional-services .content-page p {
    background: none repeat scroll 0 0 #F1F1F2;
    color: #253D7F;
    font-size: 0.9em;
    line-height: 1.4em;
    margin: 0 0 1em;
    overflow: hidden;
    padding: 0.5em 1em;
    margin-bottom: 0px;
}

.professional-services .image-container {
    background: none repeat scroll 0 0 #FFFFFF !important;
}

.professional-services .leftpane h2 {
    margin-bottom: 0.3em;
    margin-top: 0.5em;
}

.professional-services .subfooter {
    background-color: #FFFFFF !important;
}

.professional-services .banner h1 {
    color: #FFFFFF;
    font-size: 3.5em;
    font-weight: normal;
    line-height: 1em;
    /*margin: 0 auto;
    padding: 0 0 0 1px;*/
    margin-top: 0em;
    margin-right: 0em;
    margin-bottom: 0em;
    margin-left: 3.3em;
    padding-top: 0.5em;
    width: 16.5%;
}


.professional-services .banner h1 {
    padding: 0.5em 0 0 !important;
}

.professional-services #menuElem > .HighLighted > a, #menuElem > .HighLighted > a, #menuElem > .highlighted > a {
    font-weight: bold;
}

.professional-services .banner img {
    /*display: none;*/
}
/*Training*/
.training .content-page p {
    background: none repeat scroll 0 0 #F1F1F2;
    color: #253D7F;
    font-size: 0.9em;
    line-height: 1.4em;
    margin: 0 0 1em;
    overflow: hidden;
    padding: 0.5em 1em;
    margin-bottom: 0px;
}

.training .content-page ul {
    background: none repeat scroll 0 0 #F1F1F2;
    padding-left: 1.5em;
}


    .training .content-page ul li a {
        color: #0C95D3;
        font-size: 1.2em;
        font-weight: normal;
        line-height: 1em;
        margin: 0 0 1em;
    }

.training .content-page p a {
    color: #0C95D3;
}

.training .image-container {
    background: none repeat scroll 0 0 #FFFFFF !important;
}

.training .leftpane h2 {
    margin-bottom: 0.3em;
    margin-top: 0.5em;
}

.training .subfooter {
    background-color: #FFFFFF !important;
}

.training .banner h1 {
    color: #FFFFFF;
    font-size: 3.5em;
    font-weight: normal;
    line-height: 1em;
    /*margin: 0 auto;
    padding: 0 0 0 1px;*/
    margin-top: 0em;
    margin-right: 0em;
    margin-bottom: 0em;
    margin-left: 3.3em;
    padding-top: 0.5em;
    width: 16.5%;
}

.training .banner h1 {
    padding: 0.5em 0 0 !important;
}

.training #menuElem > .HighLighted > a {
    font-weight: bold;
}

.training .banner img {
    /*display: none;*/
}

.training .headerImage {
    top: 30%;
}

.training .content-page ul li :before {
    content: ">";
    display: inline-block;
    padding: 0 0 0 0.2em;
}

/*technical-support*/

.technical-support .toppane {
    float: left;
    font-size: 1.3em;
    width: 75%;
}

.technical-support .leftmenu {
    float: left;
    font-size: 1.3em;
    width: 75%;
    margin: 1em 0;
    overflow: hidden;
    position: relative;
}

    .technical-support .leftmenu #menuElem li {
        color: #253D7F;
        font-size: 1.5em;
        line-height: 1.3em;
    }

.technical-support #content .leftmenu #menuElem li {
    font-size: 1.3em;
}

.technical-support .leftmenu #menuElem li:before {
    content: ">";
    display: inline-block;
    padding: 0 0 0 0.2em;
}

.technical-support .leftmenu #menuElem li a {
    color: #253D7F;
}

.technical-support #content .leftmenu #menuElem li a {
    text-transform: none;
}

.technical-support .toppane > p {
    color: #253D7F;
    margin: 0 2em 1em 0;
}

/*.technical-support  .MainLeftPane .leftpane .message #support-table
{
    background: none repeat scroll 0 0 #F1F1F2;
    color: #253D7F;
    font-size: 0.9em;
    line-height: 1.4em;
    margin: 0 0 1em;
    overflow: hidden;
    padding: 0.5em 1em;
}*/

.technical-support .leftpane .message {
    background: none repeat scroll 0 0 #F1F1F2;
    color: #253D7F;
    /*font-size: 0.9em;*/
    line-height: 1.4em;
    /*margin: 0 0 1em;*/
    overflow: hidden;
    padding: 0.5em 1em 1.5em 1em;
}

.technical-support .content-page p {
    background: none repeat scroll 0 0 #F1F1F2;
    color: #253D7F;
    font-size: 0.9em;
}

.technical-support .leftpane .message p {
    background: none repeat scroll 0 0 #F1F1F2;
    margin: 0 0 1em;
}

.technical-support .image-container {
    background: none repeat scroll 0 0 #FFFFFF !important;
}

.technical-support #menuElem > .HighLighted > a {
    font-weight: bold;
}

.technical-support .leftpane h2 {
    color: #253D7F;
    font-size: 1.7em;
    font-weight: normal;
    line-height: 1em;
    margin: 0 0 0.2em;
    background: none repeat scroll 0 0 #FFFFFF !important;
}

.technical-support #support-table tr td strong {
    /*font-size: 0.9em;*/
    line-height: 1.4em;
    font-weight: normal;
}

.technical-support #support-table tr td a {
    color: #0C95D3;
    font-size: 0.9em;
    line-height: 1.4em;
}

    .technical-support #support-table tr td a:hover {
        font-weight: bold;
        font-size: 0.9em;
    }

.technical-support .leftpane h2 {
    display: block;
    margin: -0.4em -0.7em 0.2em; /*-0.4em -0.7em 1em*/
    padding: 0.4em; /*0em 0.1em 0.5em*/
}

.technical-support #support-table td, .technical-support table tr td {
    font-size: 0.9em;
    padding: 0 0 0.4em;
}

.technical-support #support-table tr:last-child td {
    padding: 0 0 1em;
}

.technical-support table {
    width: 100%;
}

    .technical-support table tr td a {
        color: #0C95D3;
    }

        .technical-support table tr td a:hover {
            font-weight: bold;
        }

.technical-support .banner h1 {
    padding: 0.5em 0 0!important;
}

.headerImage p {
    display: none;
}

#content .toppane .contentImage img, .contentImage img {
    display: none;
}

.headerImage {
    margin: 0 auto;
    position: relative;
    text-align: right;
    width: 78%;
}

    .headerImage > img {
        bottom: 0.2em;
        height: 11.1em!important; /*10.5em;*/
        width: 26%!important;
        position: absolute;
        right: 0;
    }

.enterprise .headerImage > img {
    bottom: -2.3em;
    height: 11.1em!important; /*10.5em;*/
}

.technical-support .headerImage > img {
    bottom: -2.3em;
}

.leftpane .contentImage > p {
    color: #253D7F;
    margin: 0 2em 1em 0;
}

.enterprise .banner h1 {
    padding: 1.5em 0 0 !important;
}

.tv-broadcasters .headerImage {
    top: 9%;
}

/*product>network*/
.banner h1 {
    padding: 1.2em 0 0 !important;
}

.subnav > ul > li:hover > ul {
    display: block !important;
}

/*product*/

.product strong {
    color: #1568B3;
    float: left;
    width: 16em;
}

.product a {
    color: #1568B3;
}

    .product a:hover {
        color: #1796D3;
    }

.product-info {
    background: none repeat scroll 0 0 #F1F1F2;
    padding-top: 50px;
}

.innovation .product-info {
    background: none;
    padding-top: 0;
}

.product-info h3 {
    font-size: 1.2em;
    font-weight: normal;
    margin: 0 0 0.6em;
    color: #6D6F71;
}

.col {
    background: none repeat scroll 0 0 #1796D3;
    color: #FFFFFF;
    max-width: 62em;
    overflow: hidden;
}

.prodlm .col {
    float: left;
    width: 50%;
}

.parent .txt {
    font-size: 1.5em;
    font-weight: normal;
    line-height: 1.7em;
}


.parent > ul {
    list-style: none outside none;
    margin: 0 0 1em;
    /* Change By Prashant - start */
    overflow: visible;
    /* Change By Prashant - end */
}

.info-text:before {
    color: #000000;
    display: inline-block;
    padding: 0 0.2em;
}

.info-text {
    color: #FFFFFF;
}

.video-box > div {
    float: right;
}

.text {
    color: #253D7F;
    font-size: 0.9em;
}

    .text > p {
        margin: 0 0 1.5em;
    }

.col li .sprite a {
    background: url(http://www.imaginecommunications.com/Imagine/asset/images/icon-a.jpg) left top no-repeat;
    color: #FFFFFF;
    line-height: 0.7em;
    padding: 0 0 0 1.5em;
    text-decoration: none;
}

    .col li .sprite a:hover {
        background-position: left bottom;
        font-weight: bold;
    }

.col li .sprite a {
    background-size: 1em auto;
}

.data {
    padding: 0 1em;
}

.products table {
    width: 100%;
}

    .products table td {
        width: 50%;
    }

/* New Css 5 March 2014 */
.fortabs h2 {
    font-size: 1.9em;
    margin: 0 0 0.2em;
    text-transform: none;
}

.leftpane.fortabs > h4, .leftpane.fortabs > strong.title {
    color: #6D6F71;
    font-size: 1.3em !important;
    font-weight: normal;
    margin: 0 0 0.4em !important;
}

.fortabs h2, .leftpane.fortabs h1 {
    font-size: 1.9em;
    margin: 0 0 0.2em !important;
    text-transform: none;
}

.leftpane.fortabs > h4 {
    color: #6D6F71;
    font-size: 1.3em;
    font-weight: normal;
    margin: 0 0 0.4em;
}

#tabs {
    max-width: 62em;
    overflow: hidden;
    position: relative;
}

.ui-tabs-nav {
    overflow: hidden;
    position: relative;
    width: 100%;
}

    .ui-tabs-nav li {
        float: left;
        width: 14.1%;
        padding: 0.2em 0 0 0;
    }

        .ui-tabs-nav li:last-child a {
            border-right: 0;
        }

        .ui-tabs-nav li a {
            background: none repeat scroll 0 0 #E6E7E8;
            border-bottom: 0.1em solid #6D6F71;
            border-right: 0.1em solid #6D6F71;
            color: #6D6F71;
            display: block;
            height: 3em;
            padding: 0.3em 0 0 0.3em;
            font-size: .8em;
        }

    .ui-tabs-nav .ui-tabs-active {
        background: #F1F1F2;
    }

        .ui-tabs-nav .ui-tabs-active a {
            background: #F1F1F2;
            border-bottom: 0.1em solid #F1F1F2;
            color: #0C95D3;
            font-weight: bold;
        }

.ui-tabs-panel {
    background: none repeat scroll 0 0 #F1F1F2;
    color: #6D6F71;
    font-size: 0.9em;
    overflow: hidden;
    padding: 2em 1.5em;
    position: relative;
}

.tab1-left {
    float: left;
    width: 45%;
}

    .tab1-left p {
        margin: 0 0 1em;
    }

.learn-box ul li a {
    background-size: 1em auto;
    display: block;
    line-height: 1.2em;
}

.learn-box ul li strong > span, .learn-box ul li strong > span:hover {
    background-size: 1em auto;
    line-height: 1.2em;
}

.tab1-right {
    float: right;
    position: relative;
    width: 45%;
}

    .tab1-right .forimg {
        float: none;
        height: 18em;
        margin: 0 0 1.2em;
        width: 100%;
    }

.ui-tabs-panel h5, .ui-tabs-panel strong.txt, .ui-tabs-panel strong.title {
    color: #0C95D3;
    font-size: 1.01em;
    margin: 0 0 0.4em;
}

.ui-tabs-panel h6 {
    font-size: 1.01em;
    margin: 0 0 0.4em;
}

.sheet-list {
    overflow: hidden;
    position: relative;
}

    .sheet-list li {
        margin: 0 0 0.4em;
    }

        .sheet-list li a, .column .products a {
            background: url(http://www.imaginecommunications.com/Imagine/asset/images/list-2.png) left top no-repeat;
            color: #6D6F71;
            display: block;
            line-height: 1.1em;
            padding: 0 0 0 1.2em;
            text-decoration: none;
            background-size: 1em auto;
        }

            .sheet-list li a:hover, .column .products a:hover {
                background: url(http://www.imaginecommunications.com/Imagine/asset/images/list-2hover.png) left top no-repeat;
                font-weight: bold;
                color: #0c95d3;
                background-size: 1em auto;
            }

/*.column ul li
{
    color: #6D6F71;
}
.column ul li:hover
{
     color: #0c95d3;
}*/


.featut-list {
    list-style: disc inside none;
    overflow: hidden;
    position: relative;
    margin: 0 0 2em;
}

    .featut-list > li {
        line-height: 1.7em;
        list-style: disc inside none;
    }

    .featut-list ul li {
        list-style: circle inside none;
        margin: 0 0 0 1em;
    }

    .featut-list li a, .ui-tabs-panel p a {
        color: #6d6f71;
    }

        .featut-list li a:hover, .ui-tabs-panel p a:hover, .ui-tabs-panel p strong a {
            color: #0c95d3;
        }

.tab3-img {
    background: none repeat scroll 0 0 #92278F;
    height: 15em;
    margin: 0.4em 0 2em;
    overflow: hidden;
    position: relative;
    width: 100%;
}

.list-img-text {
    overflow: hidden;
    position: relative;
}

    .list-img-text li {
        float: left;
        margin: 0 2% 0 0;
        width: 48%;
    }


.slideset .slide img {
    display: block;
    margin: 0 auto 26px;
    max-height: 321px;
    max-width: 321px;
}

.ui-tabs-panel .two-columns {
    background: none repeat scroll 0 0 #F1F1F2;
    overflow: hidden;
    padding: 0 1em 1em;
    position: relative;
}

    .ui-tabs-panel .two-columns .column {
        float: left;
        margin: 0 1% 0 0;
        position: relative !important;
        width: 49%;
    }

.ui-tabs-panel .column .products a .info-text {
    color: #6D6F71;
}

    .ui-tabs-panel .column .products a .info-text:hover { /*color: #0C95D3;*/
    }

.ui-tabs-panel > ul li {
    line-height: 1.7em;
    list-style: disc inside none;
}

    .ui-tabs-panel > ul li ul li {
        list-style: circle inside none;
        margin: 0 0 0 1em;
    }



/*Enterprise*/
/* Change By Prashant Starts */
.enterprise-education-government .banner {
    background: none repeat scroll 0 0 #A9A9A9;
}

.enterprise-education-government .nav.top > ul > li.active {
    background: transparent url(http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png) repeat;
}

.enterprise-education-government .nav.top > ul > li:hover, .enterprise-education-government .nav ul li ul li ul, .enterprise-education-government .nav > ul > li > ul > li {
    background-color: transparent;
}
/* Change By Prashant Ends */
.enterprise-education-government .banner h1 {
    width: 35.5%;
    margin-left: 3.3em;
    margin-top: -0.7em;
}

.enterprise-education-government .image-container {
    background: none repeat scroll 0 0 #FFFFFF !important;
}

.enterprise-education-government .toppane {
    float: left;
    font-size: 1.3em;
    width: 75%;
}

    .enterprise-education-government .toppane p {
        color: #253D7F;
        margin: 0 2em 1em 0;
    }

.enterprise-education-government .middlepane {
    width: 75%;
    clear: both;
    overflow: hidden;
    /*	padding-top: 1em;*/
}

    .enterprise-education-government .middlepane .two-columns {
        clear: both;
        margin-bottom: 7em;
    }

        .enterprise-education-government .middlepane .two-columns .column img {
            float: left;
            margin: 0 1em 0 0;
            height: 20em;
            /*width: 48%;*/
        }


        .enterprise-education-government .middlepane .two-columns .column p {
            color: #253D7F;
        }

    .enterprise-education-government .middlepane .left-text {
        float: left;
        margin: 0 1em 0 0;
        color: #253D7F;
        /*width: 45%;*/
    }

.enterprise-education-government .bottompane {
    background: none repeat scroll 0 0 #A9A9A9;
    color: #FFFFFF;
    overflow: hidden;
    padding: 1em 0;
    width: 72.5%;
    margin-top: 2em;
}

    .enterprise-education-government .bottompane h3,
    .network-operators .bottompane h3 {
        color: #253D7F;
        font-weight: normal;
        line-height: 1em;
        margin: 0 0 0.2em;
        font-size: 2.1em;
    }

    .enterprise-education-government .bottompane .sol-box {
        background: none repeat scroll 0 0 #A9A9A9;
        padding-top: 2em;
    }

    .enterprise-education-government .bottompane .tab-img img {
        display: block;
        width: 70% !important;
        border: 1em solid #FFFFFF;
        height: 8em !important;
    }

    .enterprise-education-government .bottompane a {
        float: left;
        margin: 0 0 0.9em 2.3%;
        position: relative;
        width: 22%;
    }

    .enterprise-education-government .bottompane .blu-div {
        width: 10em;
        height: 10em;
    }

.enterprise-education-government .sol-box .imgsol img {
    height: 8em !important;
    width: 8em !important;
    cursor: pointer;
}

.enterprise-education-government .sol-box ul {
    margin: 0.5em 0 0 3em;
}

.enterprise-education-government .sol-box li a {
    padding: 0.4em 0 0 0;
    width: 7em;
}

.enterprise-education-government .bottompane .tab-box .tab-link span {
    color: #FFFFFF;
    display: block;
    font-size: 2em;
    line-height: 1em;
    padding: 0.4em 0 0;
    text-decoration: none;
}

    .enterprise-education-government .bottompane .tab-box .tab-link span:hover {
        color: #0C95D3;
    }

.enterprise-education-government #menuElem > .HighLighted > a, #menuElem > .HighLighted > a, #menuElem > .highlighted > a {
    /*font-weight: normal;*/
}

.enterprise-education-government .nav ul li ul li span {
    font-size: 0.8em !important;
}

.enterprise-education-government .sol-box li:hover .blu-div {
    display: block;
}

/*communication-service-providers*/
/* Change By Prashant Starts */
.communication-service-providers .banner {
    background: none repeat scroll 0 0 #A9A9A9;
}

.communication-service-providers .nav.top > ul > li.active {
    background: transparent url(http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png) repeat;
}

.communication-service-providers .nav.top > ul > li:hover, .communication-service-providers .nav ul li ul li ul, .communication-service-providers .nav > ul > li > ul > li {
    background-color: transparent;
}
/* Change By Prashant Ends */
.communication-service-providers .banner h1 {
    width: 34.5%;
    margin-left: 3.3em;
    margin-top: -0.7em;
}

.communication-service-providers .image-container {
    background: none repeat scroll 0 0 #FFFFFF !important;
}

.communication-service-providers .toppane {
    float: left;
    font-size: 1.3em;
    width: 75%;
}

    .communication-service-providers .toppane p {
        color: #253D7F;
        margin: 0 2em 1em 0;
    }

.communication-service-providers .middlepane {
    width: 75%;
    clear: both;
    overflow: hidden;
    padding-top: 1em;
}

    .communication-service-providers .middlepane .two-columns {
        clear: both;
        margin-bottom: 11em;
    }

        .communication-service-providers .middlepane .two-columns .column img {
            float: left;
            margin: 0 1em 0 0;
            height: 20em;
            /*width: 48%;*/
        }


        .communication-service-providers .middlepane .two-columns .column p {
            color: #253D7F;
        }

    .communication-service-providers .middlepane .left-text {
        float: left;
        margin: 0 1em 0 0;
        color: #253D7F;
        /*width: 45%;*/
    }

.communication-service-providers .bottompane {
    background: none repeat scroll 0 0 #A9A9A9;
    color: #FFFFFF;
    overflow: hidden;
    padding: 1em 0;
    width: 72.5%;
    margin-top: 2em;
}

    .communication-service-providers .bottompane .tab-img img {
        display: block;
        width: 70% !important;
        border: 1em solid #FFFFFF;
        height: 8em !important;
    }

    .communication-service-providers .bottompane a {
        float: left;
        margin: 0 0 0.9em 2.3%;
        position: relative;
        width: 22%;
    }

    .communication-service-providers .bottompane .tab-box .tab-link span {
        color: #FFFFFF;
        display: block;
        font-size: 2em;
        line-height: 1em;
        padding: 0.4em 0 0;
        text-decoration: none;
    }

        .communication-service-providers .bottompane .tab-box .tab-link span:hover {
            color: #0C95D3;
        }

.communication-service-providers #menuElem > .HighLighted > a, #menuElem > .HighLighted > a, #menuElem > .highlighted > a {
    /*font-weight: normal;*/
}

.communication-service-providers .nav ul li ul li span {
    font-size: 0.8em !important;
}

.communication-service-providers .bottompane a.tab-box:hover .tab-img:before {
    background: url("http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png") repeat scroll left top rgba(0, 0, 0, 0);
    content: "";
    display: block;
    height: 10em;
    position: absolute;
    width: 86%;
}

.communication-service-providers .bottompane a.tab-box:hover .tab-link span {
    color: #0C95D3;
}
/*{
      
      background: none repeat scroll 0 0 #FF0000;
}*/

/*network-operators*/
/* Change By Prashant Starts */
.network-operators .banner {
    background: none repeat scroll 0 0 #A9A9A9;
}

.network-operators .nav.top > ul > li.active {
    background: transparent url(http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png) repeat;
}

.network-operators .nav.top > ul > li:hover,
.network-operators .nav ul li ul li ul, .network-operators .nav > ul > li > ul > li {
    background-color: transparent;
}
/* Change By Prashant Starts */
.network-operators .banner h1 {
    width: 27.5%;
    margin-left: 3.3em;
    margin-top: -0.7em;
}

.network-operators .image-container {
    background: none repeat scroll 0 0 #FFFFFF !important;
}

.network-operators .toppane {
    float: left;
    font-size: 1.3em;
    width: 75%;
}

    .network-operators .toppane p {
        color: #253D7F;
        margin: 0 2em 1em 0;
    }

.network-operators .middlepane {
    width: 75%;
    clear: both;
    overflow: hidden;
    padding-top: 1em;
}

    .network-operators .middlepane .two-columns {
        clear: both;
        margin-bottom: 11em;
    }

        .network-operators .middlepane .two-columns .column img {
            float: left;
            margin: 0 1em 0 0;
            height: 20em;
            /*width: 48%;*/
        }


        .network-operators .middlepane .two-columns .column p {
            color: #253D7F;
        }

    .network-operators .middlepane .left-text {
        float: left;
        margin: 0 1em 0 0;
        color: #253D7F;
        /*width: 45%;*/
    }

.network-operators .bottompane {
    background: none repeat scroll 0 0 #A9A9A9;
    color: #FFFFFF;
    overflow: hidden;
    padding: 1em 0;
    width: 72.5%;
    margin-top: 2em;
}

    .network-operators .bottompane .tab-img img {
        display: block;
        width: 70% !important;
        border: 1em solid #FFFFFF;
        height: 8em !important;
    }

    .network-operators .bottompane a {
        float: left;
        margin: 0 0 0.9em 2.3%;
        position: relative;
        width: 22%;
    }

    .network-operators .bottompane .tab-box .tab-link span {
        color: #FFFFFF;
        display: block;
        font-size: 2em;
        line-height: 1em;
        padding: 0.4em 0 0;
        text-decoration: none;
    }

        .network-operators .bottompane .tab-box .tab-link span:hover {
            color: #0C95D3;
        }

.network-operators #menuElem > .HighLighted > a, #menuElem > .HighLighted > a, #menuElem > .highlighted > a {
    /*font-weight: normal;*/
}

.network-operators .nav ul li ul li span {
    font-size: 0.8em !important;
}

.network-operators .bottompane a.tab-box:hover .tab-img:before { /*:hover*/
    background: url("http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png") repeat scroll left top rgba(0, 0, 0, 0);
    content: "";
    display: block;
    height: 10em;
    position: absolute;
    width: 86%;
}

.network-operators .bottompane a.tab-box:hover .tab-link span {
    color: #0C95D3;
}

/*radio-broadcasters*/
/* Changes Done By Prashant Starst */
.radio-broadcasters .banner {
    background: none repeat scroll 0 0 #A9A9A9;
}

.radio-broadcasters .nav.top > ul > li.active {
    background: transparent url(http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png) repeat;
}

.radio-broadcasters .nav.top > ul > li:hover,
.radio-broadcasters .nav ul li ul li ul, .radio-broadcasters .nav > ul > li > ul > li {
    background-color: transparent;
}
/* Changes Done By Prashant Ends */
.radio-broadcasters .banner h1 {
    width: 28.5%;
    margin-left: 3.3em;
    margin-top: -0.7em;
}

.radio-broadcasters .image-container {
    background: none repeat scroll 0 0 #FFFFFF !important;
}

.radio-broadcasters .toppane {
    float: left;
    font-size: 1.3em;
    width: 75%;
}

    .radio-broadcasters .toppane p {
        color: #253D7F;
        margin: 0 2em 1em 0;
    }

.radio-broadcasters .middlepane {
    width: 75%;
    clear: both;
    overflow: hidden;
    padding-top: 1em;
}

    .radio-broadcasters .middlepane .two-columns {
        clear: both;
        margin-bottom: 11em;
    }

        .radio-broadcasters .middlepane .two-columns .column img {
            float: left;
            margin: 0 1em 0 0;
            height: 20em;
            /*width: 48%;*/
        }


        .radio-broadcasters .middlepane .two-columns .column p {
            color: #253D7F;
        }

    .radio-broadcasters .middlepane .left-text {
        float: left;
        margin: 0 1em 0 0;
        color: #253D7F;
        /*width: 45%;*/
    }

.radio-broadcasters .bottompane {
    background: none repeat scroll 0 0 #A9A9A9;
    color: #FFFFFF;
    overflow: hidden;
    padding: 1em 0;
    width: 72.5%;
    margin-top: 2em;
}

    .radio-broadcasters .bottompane .tab-img img {
        display: block;
        width: 70%;
        border: 1em solid #FFFFFF;
        height: 8em !important;
    }

    .radio-broadcasters .bottompane a {
        float: left;
        margin: 0 0 0.9em 2.3%;
        position: relative;
        width: 22%;
    }

    .radio-broadcasters .bottompane .tab-box .tab-link span {
        color: #FFFFFF;
        display: block;
        font-size: 2em;
        line-height: 1em;
        padding: 0.4em 0 0;
        text-decoration: none;
    }

        .radio-broadcasters .bottompane .tab-box .tab-link span:hover {
            color: #0C95D3;
        }

.radio-broadcasters #menuElem > .HighLighted > a, #menuElem > .HighLighted > a, #menuElem > .highlighted > a {
    /*font-weight: normal;*/
}

.radio-broadcasters .nav ul li ul li span {
    font-size: 0.8em !important;
}

.radio-broadcasters .bottompane a.tab-box:hover .tab-img:before { /*:hover*/
    background: url("http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png") repeat scroll left top rgba(0, 0, 0, 0);
    content: "";
    display: block;
    height: 10em;
    position: absolute;
    width: 86%;
}

.radio-broadcasters .bottompane a.tab-box:hover .tab-link span {
    color: #0C95D3;
}
/*radio-broadcasters*/
/* Changes Done By Prashant starts*/
.sports-and-live-events .banner {
    background: none repeat scroll 0 0 #A9A9A9;
}

.sports-and-live-events .nav.top > ul > li.active {
    background: transparent url(http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png) repeat;
}

.sports-and-live-events .nav.top > ul > li:hover,
.sports-and-live-events .nav ul li ul li ul, .sports-and-live-events .nav > ul > li > ul > li {
    background-color: transparent;
}
/* Changes Done By Prashant  ends*/
.sports-and-live-events .banner h1 {
    width: 28.5%;
    margin-left: 3.3em;
    margin-top: -0.7em;
}

.sports-and-live-events .image-container {
    background: none repeat scroll 0 0 #FFFFFF !important;
}

.sports-and-live-events .toppane {
    float: left;
    font-size: 1.3em;
    width: 75%;
}

    .sports-and-live-events .toppane p {
        color: #253D7F;
        margin: 0 2em 1em 0;
    }

.sports-and-live-events .middlepane {
    width: 75%;
    clear: both;
    overflow: hidden;
    padding-top: 1em;
}

    .sports-and-live-events .middlepane .two-columns {
        clear: both;
        margin-bottom: 5em;
    }

        .sports-and-live-events .middlepane .two-columns .column img {
            float: left;
            margin: 0 1em 0 0;
            height: 20em;
            /*width: 48%;*/
        }

        .sports-and-live-events .middlepane .two-columns .column p {
            color: #253D7F;
        }

    .sports-and-live-events .middlepane .left-text {
        float: left;
        margin: 0 1em 0 0;
        color: #253D7F;
        /* width: 45%;*/
    }

.sports-and-live-events .bottompane {
    background: none repeat scroll 0 0 #A9A9A9;
    color: #FFFFFF;
    overflow: hidden;
    padding: 1em 0;
    width: 72.5%;
    margin-top: 2em;
}

    .sports-and-live-events .bottompane .tab-img img {
        display: block;
        width: 70% !important;
        border: 1em solid #FFFFFF;
        height: 8em !important;
    }

    .sports-and-live-events .bottompane a {
        float: left;
        margin: 0 0 0.9em 2.3%;
        position: relative;
        width: 22%;
    }

    .sports-and-live-events .bottompane .tab-box .tab-link span {
        color: #FFFFFF;
        display: block;
        font-size: 2em;
        line-height: 1em;
        padding: 0.4em 0 0;
        text-decoration: none;
    }

        .sports-and-live-events .bottompane .tab-box .tab-link span:hover {
            color: #0C95D3;
        }

.sports-and-live-events #menuElem > .HighLighted > a, #menuElem > .HighLighted > a, #menuElem > .highlighted > a {
    /*font-weight: normal;*/
}

.sports-and-live-events .nav ul li ul li span {
    font-size: 0.8em !important;
}

.sports-and-live-events .bottompane a.tab-box:hover .tab-img:before {
    background: url("http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png") repeat scroll left top rgba(0, 0, 0, 0);
    content: "";
    display: block;
    height: 10em;
    position: absolute;
    width: 86%;
}

.sports-and-live-events .bottompane a.tab-box:hover .tab-link span {
    color: #0C95D3;
}
/*tv-broadcasters*/
/* Changes Done by Prashant Starts */
.tv-broadcasters .banner {
    background: none repeat scroll 0 0 #A9A9A9;
}

.tv-broadcasters .nav.top > ul > li.active {
    background: transparent url(http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png) repeat;
}

.tv-broadcasters .nav.top > ul > li:hover,
.tv-broadcasters .nav ul li ul li ul, .tv-broadcasters .nav > ul > li > ul > li {
    background-color: transparent;
}
/* Changes Done by Prashant Ends */
.tv-broadcasters .banner h1 {
    width: 28.5%;
    margin-left: 3.3em;
    margin-top: -0.7em;
}

.tv-broadcasters .image-container {
    background: none repeat scroll 0 0 #FFFFFF !important;
}

.tv-broadcasters .toppane {
    float: left;
    font-size: 1.3em;
    width: 75%;
}

    .tv-broadcasters .toppane p {
        color: #253D7F;
        margin: 0 2em 1em 0;
    }

.tv-broadcasters .middlepane {
    width: 75%;
    clear: both;
    overflow: hidden;
    padding-top: 1em;
}

    .tv-broadcasters .middlepane .two-columns {
        clear: both;
        margin-bottom: 11em;
    }

        .tv-broadcasters .middlepane .two-columns .column img {
            float: left;
            margin: 0 1em 0 0;
            height: 20em;
            /*width: 48%;*/
        }


        .tv-broadcasters .middlepane .two-columns .column p {
            color: #253D7F;
        }

    .tv-broadcasters .middlepane .left-text {
        float: left;
        margin: 0 1em 0 0;
        color: #253D7F;
        /*width: 45%;*/
    }

.tv-broadcasters .bottompane {
    background: none repeat scroll 0 0 #A9A9A9;
    color: #FFFFFF;
    overflow: hidden;
    padding: 1em 0;
    width: 72.5%;
    margin-top: 2em;
}

    .tv-broadcasters .bottompane .tab-img img {
        display: block;
        width: 70% !important;
        border: 1em solid #FFFFFF;
        height: 8em !important;
    }

    .tv-broadcasters .bottompane a {
        float: left;
        margin: 0 0 0.9em 2.3%;
        position: relative;
        width: 22%;
        height: 220px;
    }

    .tv-broadcasters .bottompane .tab-box .link-title {
        color: #FFFFFF;
        display: block;
        font-size: 2em;
        line-height: 1em;
        padding: 0.4em 0 0;
        text-decoration: none;
    }

        .tv-broadcasters .bottompane .tab-box .link-title:hover {
            color: #0C95D3;
        }

.tv-broadcasters #menuElem > .HighLighted > a, #menuElem > .HighLighted > a, #menuElem > .highlighted > a {
    /*font-weight: normal;*/
}

.tv-broadcasters .nav ul li ul li span {
    font-size: 0.8em !important;
}

.tv-broadcasters .bottompane a.tab-box:hover .tab-img:before {
    background: url("http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png") repeat scroll left top rgba(0, 0, 0, 0);
    content: "";
    display: block;
    height: 10em;
    position: absolute;
    width: 86%;
}

.tv-broadcasters .bottompane a.tab-box:hover .link-title {
    color: #0C95D3;
}

/*Issue Fixes*/
/*Date : March 06, 2014*/
.portfolio-box {
    background: none repeat scroll 0 0 #F1F1F2;
    color: #6D6F71;
    max-width: 60em;
    overflow: hidden;
    padding: 1em;
}

.list-media {
    margin: 0 0 1em;
    overflow: hidden;
    position: relative;
}

    .list-media li {
        background: none repeat scroll 0 0 #FFFFFF;
        float: left;
        height: 13em;
        margin: 0 1% 1.5% 0;
        width: 24%;
    }

        .list-media li img {
            margin: 0 0 0.3em;
            /*width: 100%;
            height: 100%;*/
        }

    .list-media .hrrProdImg {
        /*height: 6.2em;*/
    }

.hrrProdImg img {
    /*max-height:130px;*/
    max-width: 160px;
}

.list-media li a, .portfolio-box li a {
    color: #6D6E71;
    display: block;
    overflow: hidden;
}

    .list-media li a span h1, .portfolio-box li a span h1 /*.list-media li a span strong,*/ {
        color: #1568B3;
        display: block;
        font-size: 0.9em !important;
    }

    .list-media li a span strong, .portfolio-box li a span strong /*.list-media li a span em,*/ {
        font-size: 0.7em !important;
        font-style: normal !important;
        line-height: 1.3em;
        font-weight: normal;
    }

    .portfolio-box li a span h1 {
        float: left;
        width: 24%;
    }

    .list-media li a span h1 {
        width: 90%;
    }

    .list-media li a span strong {
        display: block;
    }

.banner .breadcrumbs {
    display: none;
}

.portfolio-box h4 {
    font-size: 1.2em;
    font-weight: normal;
    margin: 0 0 0.6em;
}

.portfolio-box > p strong {
    color: #1568B3;
    float: left;
    width: 50%;
}

.portfolio-box > p {
    margin: 0 0 0.8em;
}

    .portfolio-box > p span {
        color: #1568B3;
    }

    .portfolio-box > p:hover strong, .portfolio-box > p:hover span, .portfolio-box li a:hover, .portfolio-box li a:hover h1 {
        color: #1796D3;
    }

.products .portfolio-box > p:hover {
    color: #1796D3;
}

.portfolio-box ul > ul {
    margin: 0 0 1em;
}

.products .leftpane h2 {
    margin-bottom: 0em !important;
}

.products .leftpane .prodlm {
    background: none repeat scroll 0 0 #1796D3;
    overflow: hidden;
}

    .products .leftpane .prodlm > h2 {
        background: none repeat scroll 0 0 #FFFFFF;
    }

.prodlm .col .data {
    padding: 1em;
}

.prod-portfolio {
    margin-bottom: 1em;
}
/*.list-media li:hover
{
	opacity: 0.5;
}*/
.list-media li:hover {
    background: url("http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png") repeat scroll left top rgba(0, 0, 0, 0);
    content: "";
    display: block;
    height: 13em;
    /*position: absolute;*/
    /*width: 24%*/
}

.subpage, .subfooter, .learn-box h2 {
    background: none repeat scroll 0 0 #FFFFFF !important;
}
/*Date : March 06, 2014 end */
/*Kiran 6 March 2014*/

/* New Css 6 March 2014 */
.product-info {
    color: #253D7F;
    font-size: 0.9em;
    line-height: 1.4em;
    margin: 0 0 1em;
    overflow: hidden;
}

    .product-info > h2 {
        background: none repeat scroll 0 0 #F1F1F2;
        margin: 0;
        padding: 1em 1em 0.5em;
    }

    .product-info .two-columns {
        background: none repeat scroll 0 0 #F1F1F2;
        overflow: hidden;
        padding: 0 1em 1em;
        position: relative;
    }

.two-columns .column {
    float: left;
    margin: 1em 1% 0 0;
    position: relative !important;
    width: 49%;
}

.two-columns .deliver {
    background: none repeat scroll 0 0 #A9A9A9 !important;
    color: #FFFFFF;
    padding: 2em 1.5em;
}

.two-columns .title {
    border-bottom: 0.1em solid #FFFFFF;
    display: block;
    font-size: 1.5em;
    line-height: 1em;
    margin: 0 0 0.3em;
    padding: 0 0 0.3em;
    text-transform: uppercase;
}

.two-columns .deliver ul {
    list-style: disc inside none;
}

    .two-columns .deliver ul li {
        list-style: disc inside none;
        margin: 0 0 0.5em;
        padding: 0 3em 0 0;
    }

.two-columns .left-text {
    line-height: 1.3em;
    padding: 0 0.5em 0 0;
}

.popup-diagram {
    display: block;
}

    .popup-diagram img {
        box-shadow: -0.5em 0.5em #85878A;
        margin: 1em 0 0;
        width: 100%;
    }

    .popup-diagram span {
        color: #0c95d3;
    }

.product-info .full-width {
    background: none repeat scroll 0 0 #FFFFFF;
    padding: 1em;
}

    .product-info .full-width .column > img {
        max-width: 100%;
    }

    .product-info .full-width:nth-child(even) .column {
        float: right;
    }

.product-info .list-media img {
    display: block;
}

.product-info .list-media {
    background: none repeat scroll 0 0 #F1F1F2;
    padding: 2em 2em 0;
}

    .product-info .list-media li {
        margin: 0 2% 4% 3%;
        width: 28%;
    }

.product-info .featured-sol-img {
    height: 10em;
    overflow: hidden;
}

.work-diagram {
    overflow: hidden;
    position: relative;
}

    .work-diagram .two-columns {
        height: auto !important;
    }

        .work-diagram .two-columns .left-text {
            line-height: 1.2em;
            color: #253d7f;
        }

            .work-diagram .two-columns .left-text p {
                margin: 0 0 1.5em;
            }

            .work-diagram .two-columns .left-text a {
                color: #0C95D3;
            }

        .work-diagram .two-columns img {
            padding: 2em 0 0;
        }

.learn-box .col {
    /*padding: 0 1em;*/
}

.leftpane > * {
    max-width: 62em;
}

.learn-box .col li > strong {
    display: block;
    font-size: 1.3em;
    margin: 0 0 0.4em;
}
/* New Css 7 March 2014 */
/*.media .top-links
{
    padding: 6em 0 0;
}*/

.media #content {
    padding: 0em 0 0;
}

    .media #content .page-title h1.fs-3 {
        margin: 0;
        padding: 0;
        font-size: 3.2em!important;
    }

.media .homepage-block-container {
    left: 10%!important;
}

.media .channel-block p {
    display: block;
}

.alinroght {
    text-align: right;
}

.media .homepage-block-container .color-block .block-text {
    margin: 0 2em !important;
}

.media .homepage-block-container .color-block .block-text {
    background: none repeat scroll 0 0 rgba(0, 0, 0, 0);
    font-size: 0.9em;
    line-height: 1.4em;
    margin: 0 1.4em !important;
    padding: 0 !important;
}

.media .block-title {
    margin: 0 1em;
    /*font-weight: normal;*/
}

.alinroght {
    margin: 1em 0;
}

.media .optimize-block img {
    margin: 0.5em 0 0;
}

.media .color-block h3 {
    font-weight: normal;
    margin: 0 0 0.5em;
}

.arnav {
    overflow: hidden;
    padding-bottom: 4em;
}

    .arnav li {
        border-bottom: 0.1em solid #FFFFFF;
        font-size: 1.2em;
        line-height: 2em;
    }

        .arnav li:last-child {
            border: none;
        }

        .arnav li a:hover {
            font-weight: bold;
            color: #1796d3 !important;
        }

.contentFollowus {
    float: right;
    width: 23%;
}

    .twitter-feed h6, .contentFollowus h6 {
        border-bottom: 0.1em solid #1796D3;
        color: #1796D3;
        font-size: 1.5em;
        font-weight: normal;
        padding: 0.5em 0;
    }

.twitter-feed .twitter-post {
    color: #58585A;
    font-size: 0.9em;
    overflow: hidden;
    padding: 0.5em 0;
    width: auto !important;
}

    .twitter-feed .twitter-post .twitter-img {
        float: left;
        margin: 0 0.8em 0 0;
        width: 17%;
    }

    .twitter-feed .twitter-post strong {
        display: block;
        font-size: 1em;
        color: #1796D3;
    }

    .twitter-feed .twitter-post a {
        color: #1796D3;
    }


    .twitter-feed .twitter-post .twitter-text {
        float: right;
        width: 76%;
    }

.twitter-text br {
    display: none;
}

.fornews {
    padding: 1em;
}

    .fornews .headline-link {
        color: #253D7F;
        font-size: 1.5em;
        font-weight: bold;
    }

        .fornews .headline-link span {
            color: #1796D3;
        }

.time {
    display: block;
    font-size: 1.2em;
    margin: 0.3em 0 0;
}

.author {
    display: block;
    margin: 0.2em 0 0.8em;
}

    .author em {
        /*font-style: normal;*/
    }

.news .text p {
    font-size: 0.9em;
}

.news .text a {
    font-weight: bold;
    font-size: 1em;
    color: #1796D3;
}

.fornews h2 {
    background: none repeat scroll 0 0 #FFFFFF;
    font-size: 1.3em;
    margin: 0 -1em;
    padding: 1em 0.4em 0.1em;
    text-transform: capitalize;
}

.data {
    padding: 1em 0;
}

    .data li {
        margin: 0 0 0.4em;
        overflow: hidden;
        font-size: 0.9em;
    }

        .data li em {
            color: #58595b;
            float: left;
            font-style: normal;
            width: 9%;
        }

        .data li span {
            color: #253D7F;
            float: left;
            width: 80%;
        }

            .data li span a {
                color: #253D7F;
            }

        .data li:hover a, .data li:hover em {
            color: #1796D3;
        }

        .data li:hover em {
            font-weight: bold;
        }

.feasol-lm .info-text {
    color: #fff !important;
}

/* Change By Prashant - start */
.articles .banner {
    background: none repeat scroll 0 0 #A9A9A9;
}

.articles .nav.top > ul > li.active {
    background: transparent url(http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png) repeat;
}

.articles .nav.top > ul > li:hover, .articles .nav ul li ul {
    background-color: transparent;
}
/* Change By Prashant - end */
.articles h3 {
    font-size: 1.3em;
}

.articles-text {
    padding: 1em;
}

    .articles-text .headline-link {
        color: #253D7F;
        font-size: 1.5em;
        font-weight: bold;
    }

        .articles-text .headline-link span {
            color: #1796D3;
        }

    .articles-text h2 {
        background: none repeat scroll 0 0 #FFFFFF;
        clear: both;
        font-size: 1.3em;
        margin: 0 -1em;
        padding: 1em 0.4em 0.1em;
        text-transform: capitalize;
    }

.headline-link strong {
    font-weight: normal;
}

.articles-text .author > em {
    font-style: normal;
    display: block;
}
/* Code By Prashant Starts */
.events .banner {
    background: none repeat scroll 0 0 #1568B3;
}

.events .nav.top > ul > li.active {
    background: transparent url(http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png) repeat;
}

.events .nav.top > ul > li:hover, .events .nav ul li ul {
    background-color: transparent;
}
/* Code By Prashant Ends */

.events h3 {
    font-size: 1.3em;
}

.events .page-text > a {
    float: left;
}

.events .page-text > .text {
    float: left;
    padding: 0 1em 2em;
}

.events .page-text .name {
    color: #0C95D3;
    font-size: 1.2em;
}

.events .page-text .time {
    display: block;
    font-size: 0.9em;
    margin: 0.3em 0 0;
}

.events .portfolio {
    padding: 1.5em 1em 0 0;
}

.portfolio li {
    border-bottom: 0.11em solid #6D6F71;
    color: #253D7F;
    margin: 0 0 1em;
    padding: 0 0 1em;
}

    .portfolio li:hover {
        opacity: 1;
    }

    .portfolio li h3 {
        color: #253D7F;
        font-size: 1.4em;
        font-weight: bold;
    }

    .portfolio li h6 {
        font-size: 1.2em;
        font-weight: normal;
    }

.sf_4cols_1_25, .sf_4cols_2_25, .sf_4cols_3_25, .sf_4cols_4_25 {
    float: left;
    margin: 0;
    width: 25%;
}

.box.testimonials .sf_cols.product-info.inline-box .tab-box {
    cursor: pointer;
    height: 173px;
    margin: 0 0 10px 3px;
    position: relative;
    width: 178px;
}

.enterprise .tab-box .tab-img img {
    display: block;
    margin: 0 auto;
    position: relative;
}

/*.tab-box:hover
{
	background: linear-gradient(to bottom, #FFFFFF 0px, #FFFFFF 0px, #A5C8ED 100%, #A5C8ED 100%) repeat scroll 0 0 rgba(0, 0, 0, 0);
}

a.tab-box:hover
{
	text-decoration: none;
}*/

.mediaHtm {
    /*overflow: hidden!important;*/
}
/*Virendra 07 March 2014*/
.portfolio li img {
    float: left;
    height: 6em;
    margin: 0 1em 0 0;
    width: 10em;
}

.portfolio li h3 {
    color: #253D7F;
    font-size: 1.4em;
    font-weight: bold;
}

.addres-box, .page-text {
    background: none repeat scroll 0 0 #F1F1F2;
    color: #253D7F;
}
/* Changes By prashant starts */
.events .banner {
    background: none repeat scroll 0 0 #1568B3;
}

.events .nav.top > ul > li.active {
    background: transparent url(http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png) repeat;
}

.events .nav.top > ul > li:hover,
.events .nav ul li ul li ul, .events .nav > ul > li > ul > li {
    background-color: transparent;
}
/* Changes By prashant ends */


/*ContactUs*/

.contact-us .banner h1 {
    /*padding-top: 0.8em ;*/
}
/* Code by Prashant Starts */
.contact-us .banner {
    background: none repeat scroll 0 0 #243F81;
}

.contact-us .nav.top > ul > li.active {
    background: transparent url(http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png) repeat;
}

.contact-us .nav.top > ul > li:hover, .contact-us .LTR .nav ul li ul li ul {
    background-color: transparent;
}

.contact-us .nav ul li ul li ul {
    background-color: transparent;
}

.contact-us .nav > ul > li > ul > li {
    background-color: transparent;
}
/* Code by Prashant Starts */


.contact-us .leftpane {
    float: left;
    font-size: 1.3em;
    width: 79%; /*75%*/
}

    .contact-us .leftpane .toppane p {
        color: #253D7F;
        margin: 0 2em 1em 0;
        max-width: 40em;
    }

.contact-left {
    float: left;
    width: 33em;
}

    .contact-left table th {
        color: #253D7F;
        font-size: 1.4em;
        font-weight: normal;
        padding: 0 0 0.3em;
    }

        .contact-left table th .smaller {
            font-size: 0.8em;
        }


    .contact-left .seller-table.contact-table {
        background: none repeat scroll 0 0 #F1F1F2;
        font-size: 0.8em;
        padding: 1em;
        width: 100%;
    }

    .contact-left .seller-table.contact-table {
        font-size: 0.8em;
        border-spacing: 0;
    }

        .contact-left .seller-table.contact-table tr td {
            border-bottom: 0.1em solid #000000;
            color: #253D7F;
            padding: 0 0 0.2em;
        }

        .contact-left .seller-table.contact-table td img {
            display: none;
        }

        .contact-left .seller-table.contact-table tr td a {
            color: #58595B;
        }

.contact-right {
    float: left; /*right*/
    font-size: 0.8em;
    width: 14em;
    margin-top: 1em;
    margin-left: 1.7em;
}


    .contact-right h2 {
        font-size: 1.7em;
        /*margin: 0 0 0.2em;*/
        color: #253D7F;
        font-family: Arial;
        margin-top: -1em;
        margin-right: -3em;
        margin-bottom: 0em;
        margin-left: -1em;
        text-transform: capitalize;
        background-color: #fff;
        padding-bottom: 0.4em;
        padding-left: 0.4em;
    }


    .contact-right .products {
        background: none repeat scroll 0 0 #F1F1F2;
        font-size: 0.8em;
        padding: 1em;
        width: 100%;
    }

        .contact-right .products li {
            color: #253D7F;
            font-size: 1.8em;
            line-height: 1.4em;
            overflow: hidden;
            padding-top: 0.4em;
        }

            .contact-right .products li a {
                color: #253D7F;
            }

            .contact-right .products li:hover a {
                color: #0C95D3;
                font-weight: bold;
            }

            .contact-right .products li .more-info-arrow, .contact-right .products li .more-info-arrow a {
                float: left;
            }

                .contact-right .products li .more-info-arrow, .contact-right .products li .more-info-arrow a {
                    float: left;
                }

            .contact-right .products li a {
                color: #253D7F;
            }

.contact-us .top-links .breadcrumbs a {
    font-size: 0.9em !important;
}

.contact-us .top-links .breadcrumbs span {
    font-size: 1em !important;
}

/*.north-america .banner, .north-america .nav.top > ul > li.active, .north-america .nav.top > ul > li:hover, .north-america .nav ul li ul
{
    background: none repeat scroll 0 0 #243F81;
}*/

.north-america .banner, .north-america .nav.top > ul > li:hover {
    background: none repeat scroll 0 0 #243F81;
}


.north-america .nav ul li ul li ul {
    background: none;
    background-color: #243F81;
}

.north-america .nav > ul > li > ul > li {
    background: none;
    background-color: #243F81;
}


.north-america .banner h1 {
    color: #FFFFFF;
    font-size: 3.5em;
    font-weight: normal;
    line-height: 1em;
    margin-top: -0.5em;
    width: 77.5%;
}

.north-america .message {
    background: none repeat scroll 0 0 #F1F1F2;
    color: #58585A;
    font-size: 0.8em;
    line-height: 1.4em;
    margin: 0 0 1em;
    overflow: hidden;
    padding: 1em;
}

    .north-america .message strong {
        color: #253D7F;
        font-size: 1.4em;
        font-weight: normal;
        line-height: 1em;
        margin: 0 0 0.2em;
    }

.north-america .top-links .breadcrumbs a {
    font-size: 0.9em !important;
}

.north-america .top-links .breadcrumbs span {
    font-size: 1em !important;
}


.network-operators #menuElem > .HighLighted > a, #menuElem > .HighLighted > a, #menuElem > .highlighted > a {
    font-weight: bold;
}
/*Mahadev css 08 March*/

/*.tab-box:hover
{
	background: linear-gradient(to bottom, #FFFFFF 0px, #FFFFFF 0px, #A5C8ED 100%, #A5C8ED 100%) repeat scroll 0 0 rgba(0, 0, 0, 0);
}

a.tab-box:hover
{
	text-decoration: none;
}*/

.data li:hover em {
    color: #1796D3;
}


.addres-box, .page-text {
    background: none repeat scroll 0 0 #F1F1F2;
    color: #253D7F;
}

.NewsUp {
    margin-top: -12px !important;
}

.data li em {
    width: 16% !important;
}

.media-resources .banner, .media-resources .nav.top > ul > li.active, .media-resources .nav.top > ul > li:hover, .media-resources .nav ul li ul {
    /* Change By Prashant - start */
    /*  background: none repeat scroll 0 0 #A9A9A9;*/
    /* Change By Prashant - end */
}

.media-resources .articles-text {
    line-height: 1.5em;
    padding: 0 1em 1em;
}

    .media-resources .articles-text > p, .media-resources .page-text h4, .media-resources .page-text h4 span {
        color: #253D7F;
        margin: 0 0 0.2em;
        padding: 1em 0 0;
    }

    .media-resources .articles-text ul {
        list-style: disc inside none;
    }

        .media-resources .articles-text ul li {
            list-style: disc inside none;
            color: #0C95D3;
        }

            .media-resources .articles-text ul li a {
                color: #0C95D3;
            }

.media-resources .banner h1 {
    padding: 1em 0 0 !important;
}

.webinar-series .banner, .webinar-series .nav.top > ul > li.active, .webinar-series .nav.top > ul > li:hover, .webinar-series .nav ul li ul {
    /* Change By Prashant - start */
    /* background: none repeat scroll 0 0 #A9A9A9;*/
    /* Change By Prashant - end */
}

.webn-top {
    color: #253D7F;
    font-size: 0.9em;
    line-height: 1.4em;
    overflow: hidden;
    position: relative;
}

    .webn-top p {
        float: left;
        margin: 0 0 0.5em;
        width: 56%;
    }

    .webn-top > img {
        position: absolute;
        right: 0;
    }

.webn-mid {
    overflow: hidden;
    padding: 1em 0;
    position: relative;
}

    .webn-mid table {
        background: none repeat scroll 0 0 #F1F1F2;
        color: #253D7F;
        font-size: 0.9em;
        line-height: 1.4em;
        padding: 1em;
        width: 100%;
    }

        .webn-mid table table {
            padding: 0;
        }

        .webn-mid table td {
            background: none repeat scroll 0 0 rgba(0, 0, 0, 0) !important;
            padding: 1em 0.5em !important;
        }

            .webn-mid table td td {
                padding: 0 !important;
            }

            .webn-mid table td div .popup-youtube {
                background: none repeat scroll 0 0 #0C95D3;
                display: block;
                color: #fff;
                font-size: 1.1em !important;
                padding: 0.2em 0.5em;
            }

                .webn-mid table td div .popup-youtube:hover {
                    color: #253d7f !important;
                }

            .webn-mid table td .date {
                font-size: 0.8em;
                font-style: italic;
            }

            .webn-mid table td p .popup-youtube {
                color: #0C95D3;
                display: block;
                margin: 0 0 -0.8em;
            }

                .webn-mid table td p .popup-youtube:hover {
                    color: #253d7f !important;
                }

            .webn-mid table td a {
                color: #0C95D3;
            }

                .webn-mid table td a:hover {
                    font-weight: bold;
                }

            .webn-mid table td:last-child {
                color: #58595b;
            }

    .webn-mid .column {
        color: #58595B;
        float: left;
        font-size: 0.9em;
        line-height: 1.4em;
        margin: 0;
        padding: 1em 2em 0 0;
        width: auto !important;
    }

        .webn-mid .column img {
            margin: 0 !important;
        }

    .webn-mid .heading {
        color: #253D7F;
        font-size: 1.9em;
        font-weight: normal;
        line-height: 1.3em;
        max-width: 6em;
    }

    .webn-mid h2 {
        color: #253D7F;
        font-size: 1em;
        font-weight: bold;
        line-height: 1em;
        margin: 0;
        text-transform: uppercase;
    }

    .webn-mid .template-btn {
        background: none repeat scroll 0 0 #0C95D3;
        color: #FFFFFF;
        display: block;
        font-size: 1.1em !important;
        padding: 0.2em 0.5em;
    }
/* Change By Prashant Starts */
.nab .banner {
    background: none repeat scroll 0 0 #A9A9A9;
}

.nab .nav.top > ul > li.active {
    background: transparent url(http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png) repeat;
}

.nab .nav.top > ul > li:hover, .nab .nav ul li ul {
    background-color: transparent;
}
/* Change By Prashant Ends */
.nab-text {
    /*overflow: hidden;*/
    position: relative;
}

    .nab-text .top-content {
        background: none repeat scroll 0 0 #0C95D3;
        display: block;
        margin-top: -0.4em;
        max-width: 21em;
        padding: 1em;
    }

    .nab-text .photo {
        color: #999999;
        font: italic 14px/20px Georgia,"Times New Roman",Times,serif;
        position: absolute;
        right: -116px;
        text-align: center;
        top: 30px;
    }

    .nab-text #content {
        top: -35px;
        width: 100%;
    }

    .nab-text #content {
        float: right;
        margin-bottom: 35px;
        position: relative;
        width: 750px;
    }

    .nab-text .page-content {
        left: 0;
        position: absolute;
        top: 2em;
        width: 100%;
    }

#content #content {
    overflow: visible;
}

.sfContentBlock > div {
    padding: 0 !important;
}

.sfContentBlock table {
    max-width: 30em;
    color: #253d7f;
}

    .sfContentBlock table td > strong {
        color: #0c95d3;
    }

    .sfContentBlock table ul {
        font-size: 0.8em !important;
        list-style: disc inside none !important;
        padding: 0.8em 0 0;
    }

        .sfContentBlock table ul li {
            list-style: disc inside none;
            padding: 0 0 0.5em 0.5em;
        }

.sfContentBlock > table > tbody > tr > td {
    background: none repeat scroll 0 0 rgba(0, 0, 0, 0) !important;
}

.sfContentBlock table td {
    border-radius: 0 !important;
}

    .sfContentBlock table td a {
        display: block;
        font-size: 0.7em !important;
        line-height: 1.2em;
    }

.nab-text h3 {
    color: #253D7F;
    font-size: 1.7em;
    font-weight: normal;
    line-height: 1em;
    margin: 0 0 0.2em;
}
/* Change by Prashant Starts */
.careers .banner {
    background: none repeat scroll 0 0 #243F81;
}

.careers .nav.top > ul > li.active {
    background: transparent url(http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png) repeat;
}

.careers .nav.top > ul > li:hover, .careers .nav ul li ul {
    background-color: transparent;
}
/* Change by Prashant Ends */
.careerstop {
    overflow: hidden;
    font-size: 1em;
    color: #253d7f;
}

    .careerstop > p {
        color: #253D7F;
        float: left;
        line-height: 1.4em;
        width: 60%;
    }

        .careerstop > p a {
            color: #253D7F;
        }

    .careerstop > img {
        float: right;
    }

    .careerstop .product-category a {
        color: #0c95d3;
    }

    .careerstop .product-category .active {
        font-weight: bold;
    }

.careers .careerstop .product-category {
    width: auto;
}

.about .careerstop .desc {
    float: left;
    width: 20.2em;
}

@media screen and (-webkit-min-device-pixel-ratio:0) {
    /* Safari and Chrome, if Chrome rule needed */
    .about .careerstop .desc {
        float: left;
        width: 19em;
    }
}

.careers .careerstop > p {
    width: 55%;
}


.test-top .portfolio li p {
    margin: 0 0 0.2em;
}

.test-top .portfolio li .smaller {
    font-size: 0.9em;
    margin: 0.5em 0 0;
}

.test-top .portfolio li a {
    color: #0c95d3;
}

    .test-top .portfolio li a:hover {
        font-weight: bold;
    }

.test-top .portfolio li h3 {
    font-weight: normal;
}


/*End Mahadev*/

/*News menu*/
/* Changes By Prashant Starts  */
.agreements .banner {
    background: none repeat scroll 0 0 #243F81;
}

.agreements .nav.top > ul > li:hover {
    background: transparent url(http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png) repeat;
}
/* Changes By Prashant Starts  */

.agreements .nav ul li ul li ul {
    background-color: transparent;
}

.agreements .nav > ul > li > ul > li {
    background-color: transparent;
}

/*article menu*/

/* Changes by Prashant Starts */
.articles .banner {
    background: none repeat scroll 0 0 #A9A9A9;
}

.articles .nav.top > ul > li:hover {
    background: transparent url(http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png) repeat;
}
/* Changes by Prashant Ends */
.articles .nav ul li ul li ul {
    background-color: transparent;
}

.articles .nav > ul > li > ul > li {
    background-color: transparent;
}


/*Media Resources menu*/
/* Changes done by Prashant starts */
.media-resources .banner {
    background: none repeat scroll 0 0 #A9A9A9;
}

.media-resources .nav.top > ul > li:hover {
    background: transparent url(http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png) repeat;
}
/* Changes done by Prashant End */
.media-resources .nav ul li ul li ul {
    background-color: transparent;
}

.media-resources .nav > ul > li > ul > li {
    background-color: transparent;
}

/*Webinar-Series Menu*/
/* Change by Prashant Starts */
.webinar-series .banner {
    background: none repeat scroll 0 0 #A9A9A9;
}

.webinar-series .nav.top > ul > li:hover {
    background: transparent url(http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png) repeat;
}

.webinar-series .nav ul li ul li ul {
    background-color: transparent;
}

.webinar-series .nav > ul > li > ul > li {
    background-color: transparent;
}
/* Change by Prashant Ends */

/*Careers menu*/
/* Change by Prashant starts */
.careers .banner {
    background: none repeat scroll 0 0 #243F81; /*uncommented for main menu bagroun selcted*/
}

.careers .nav.top > ul > li:hover {
    background: transparent url(http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png) repeat; /*uncommented for main menu bagroun selcted*/
}


.careers .nav ul li ul li ul {
    background-color: transparent;
}

.careers .nav > ul > li > ul > li {
    background-color: transparent;
}
/* Change by Prashant Ends */
/*.CMSListMenuHighlightedLI
{
    text-transform: uppercase;
    color: #0895D3;
}*/

/*Innovation*/

/* Change by Prashant Starts */
.innovation .banner {
    background: none repeat scroll 0 0 #0C95D3; /*uncommented for main menu bagroun selcted*/
}

.innovation .nav.top > ul > li.active {
    background: transparent url(http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png) repeat;
}

.innovation .nav.top > ul > li:hover, .innovation .nav ul li ul {
    background-color: transparent;
}


.innovation .banner {
    background: none repeat scroll 0 0 #0C95D3;
}

.innovation .nav.top > ul > li:hover {
    background-color: transparent;
}


.innovation .nav ul li ul li ul {
    background-color: transparent;
}

.innovation .nav > ul > li > ul > li {
    background-color: transparent;
}
/* Change by Prashant Ends */
.innovation .top-links .breadcrumbs a {
    font-size: 0.9em !important;
}

.innovation .top-links .breadcrumbs span {
    font-size: 1em !important;
}

.innovation .banner h1 {
    color: #FFFFFF;
    font-size: 3.5em;
    font-weight: normal;
    line-height: 1em;
    margin: 0 auto;
    padding: 0;
    width: 77.5%;
}

.innovation .leftpane {
    color: #253D7F;
    font-size: 1em;
    line-height: 1.4em;
}

.innovation .headerImage {
    display: none;
}

.toppane {
    color: #253D7F;
    font-size: 1em;
    overflow: hidden;
}

.innovation .toppane {
    color: #253D7F;
    font-size: 1em;
    overflow: hidden;
}


    .innovation .toppane p {
        width: 52%;
    }

    .innovation .toppane > p {
        font-size: 0.9em;
    }

    .innovation .toppane > p {
        color: #253D7F;
        float: left;
        line-height: 1.4em;
        /*width: 60%;*/
    }


    .innovation .toppane > img {
        width: 45%;
    }

.innovation .top-links .breadcrumbs .CMSBreadCrumbsCurrentItem {
    color: #233D7F;
}

/*Board of directors */
/* Change by Prashant Starts */
.Board-of .banner {
    background: none repeat scroll 0 0 #243F81;
}

.Board-of .nav.top > ul > li.active {
    background: transparent url(http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png) repeat;
}

.Board-of .nav.top > ul > li:hover, .Board-of .nav ul li ul, .Board-of .nav ul li ul li ul, .Board-of .nav > ul > li > ul > li {
    background-color: transparent;
}
/* Change by Prashant Ends */
.sol-box {
    /*amol change*/
    background: none repeat scroll 0 0 #F1F1F2; /*background: #A9A9A9;*/
    /*amol change*/
}


.Board-of .sol-box li {
    float: left;
    height: 13em;
    margin: 0 4% 0.9em 1.3%;
    padding: 3%;
    position: relative;
    width: 14%;
}

.Board-of .imgsol, .Board-of .imgsol img {
    height: 9em;
    border: 0 none;
}

    .Board-of .imgsol, .Board-of .imgsol img {
        /*background: none repeat scroll 0 0 #91278F;*/
        border: 0 none;
        /*height: 9em;*/
        height: 158px;
        width: 115px;
    }

        .Board-of .imgsol img {
            /*width: 100%;*/
        }

.Board-of .sol-box li a {
    color: #58595B;
    display: block;
    font-size: 0.8em;
    line-height: 1.1em;
    padding: 0.4em 0 0;
    text-align: center;
    text-decoration: none;
}

.Board-of .sol-box.bod li:hover {
    background: #D2D3D5;
}

.Board-of .sol-box.mmgt li:hover {
    background: #FFFFFF;
}


.Board-of .sol-box li a strong {
    color: #253D7F;
    display: block;
    font-size: 1.2em;
    margin: 0 0 0 -0.5em;
}

.team-box {
    background: none repeat scroll 0 0 #F1F1F2;
    color: #253D7F;
    font-size: 0.9em;
    overflow: hidden;
    padding: 1em;
    position: relative;
}

    .team-box h2 {
        font-weight: bold;
        text-transform: capitalize;
        margin: 0 0 0.8em;
    }

        .team-box h2 span {
            color: #58595B;
            display: block;
            font-size: 0.8em;
            font-weight: normal;
        }

    .team-box > div {
        float: right;
        width: 70%;
    }

        .team-box > div p {
            margin: 0 0 1em;
        }

    .team-box > img {
        float: left;
        width: 25%;
    }

/* New Css 8 March 2014 */
/* CHange by prashant Starts */
.contacts .banner {
    background: none repeat scroll 0 0 #243F81;
}

.contacts .nav.top > ul > li.active {
    background: transparent url(http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png) repeat;
}

.contacts .nav.top > ul > li:hover, .contacts .nav ul li ul {
    background-color: transparent;
}
/* Change by prashant Ends */
.contacts .leftpane > p {
    max-width: 40em;
}

.forms {
    background: none repeat scroll 0 0 #F1F1F2;
    color: #58595B;
    font-size: 0.8em;
    margin: 0 0 2em;
    max-width: 60em;
    overflow: hidden;
    padding: 1.5em;
}

    .forms p {
        margin: 0 0 1em;
    }

.req, .form-required {
    color: #F00;
}

.form-section {
    overflow: hidden;
    position: relative;
}

    .form-section li {
        margin: 0 0 0.3em;
        overflow: hidden;
    }

        .form-section li > label, .form-section li > span {
            float: left;
            font-weight: bold;
            padding: 0.3em;
            text-align: left;
            white-space: normal;
            width: 10em;
        }

        .form-section li input[type="text"], .form-section li select {
            border: 0.2em solid #58595B;
            float: left;
            height: 1.8em;
            line-height: 1.8em;
            width: 15em !important;
        }

        .form-section li textarea {
            border: 0.2em solid #58595B;
            height: 3.8em;
            line-height: 1.8em;
            width: 15em;
        }

        .form-section li > div {
            float: left;
        }

    .form-section button, .form-section .form-submit-reset {
        background: none repeat scroll 0 0 #0C95D3;
        border: medium none;
        color: #FFFFFF;
        cursor: pointer;
        display: block;
        float: left;
        font-size: 1.1em;
        margin: 0 0.5em 0 0;
        padding: 0.2em 0.5em;
    }

/*Mahadev second update on 8March*/
.test-top {
    overflow: hidden;
    background: #f1f1f2;
    padding: 1em;
}

    .test-top .portfolio li {
        color: #58595b;
        font-size: 0.9em;
    }
/* change by prashant Starts */
.about .banner {
    background: #253d7f;
}

.about .nav.top > ul > li.active {
    background: transparent url(http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png) repeat;
}

.about .nav.top > ul > li:hover, .about .nav ul li ul {
    background-color: transparent;
}
/* change by prashant Ends */
.about .banner span:first-child {
    font-size: 0.8em;
}

.about .banner span:last-child {
    display: block;
    padding: 0 0 0 2.3em;
}

@media screen and (-webkit-min-device-pixel-ratio:0) {
    /* Safari and Chrome, if Chrome rule needed */
    .about .banner span:last-child {
        display: block;
        padding: 0 0 0 2.4em;
    }
}

.careerstop > p {
    font-size: 0.9em;
}

.midabout {
    background: none repeat scroll 0 0 #F1F1F2;
    color: #253D7F;
    font-size: 0.9em;
    overflow: hidden;
    padding: 1em;
    position: relative;
}

    .midabout .name {
        background: none repeat scroll 0 0 #FFFFFF;
        clear: both;
        display: block;
        font-size: 1.5em;
        margin: -1em -1em 1em;
        padding: 1em 1em 0.5em;
    }

    .midabout p {
        margin: 0 0 1em;
    }

    .midabout h4 {
        background: none repeat scroll 0 0 #FFFFFF;
        clear: both;
        display: block;
        font-size: 1.1em;
        margin: 0 -1em 1em;
        padding: 1em 1em 0.5em;
    }

    .midabout .block-list {
        overflow: hidden;
        padding: 0 0 6em;
        list-style: none;
        width: 100%;
    }

        .midabout .block-list > li {
            float: left;
            margin: 0 2% 0 0;
            list-style: none;
            position: relative;
            width: 23%;
            cursor: pointer;
        }

    .midabout .color-block.create-block {
        background-color: #233d7f;
    }

    .midabout .color-block1.create-block {
        background-color: #233d7f;
    }

    .midabout .color-block.create-block .block-text {
        background: url(http://www.imaginecommunications.com/Imagine/asset/images/creat.png) center bottom no-repeat;
    }

    .midabout .color-block1.create-block .block-text {
        background: url(http://www.imaginecommunications.com/Imagine/asset/images/creat.png) center bottom no-repeat;
    }

    .midabout .product-block.create-block .tab-box {
        background: url(http://www.imaginecommunications.com/Imagine/asset/images/media.png) center bottom no-repeat;
    }

    .midabout .color-block.optimize-block,
    .midabout .product-block.optimize-block {
        background-color: #0668b2;
    }

    .midabout .color-block1.optimize-block {
        background-color: #0668b2;
    }

    .midabout .color-block.optimize-block .block-text {
        background: url(http://www.imaginecommunications.com/Imagine/asset/images/optimize.png) center bottom no-repeat;
    }

    .midabout .color-block1.optimize-block .block-text {
        background: url(http://www.imaginecommunications.com/Imagine/asset/images/optimize.png) center bottom no-repeat;
    }

    .midabout .product-block.optimize-block .tab-box {
        background: url(http://www.imaginecommunications.com/Imagine/asset/images/playout.png) center bottom no-repeat;
    }

    .midabout .color-block.play-block,
    .midabout .product-block.play-block {
        background-color: #8ebace;
    }

    .midabout .color-block1.play-block {
        background-color: #8ebace;
    }

    .midabout .color-block.play-block .block-text {
        background: url(http://www.imaginecommunications.com/Imagine/asset/images/play.png) center bottom no-repeat;
    }

    .midabout .color-block1.play-block .block-text {
        background: url(http://www.imaginecommunications.com/Imagine/asset/images/play.png) center bottom no-repeat;
    }

    .midabout .product-block.play-block .tab-box {
        background: url(http://www.imaginecommunications.com/Imagine/asset/images/networking.png) center bottom no-repeat;
    }

    .midabout .color-block.deliver-block {
        background-color: #a8a8a8;
    }

    .midabout .color-block1.deliver-block {
        background-color: #a8a8a8;
    }

    .midabout .color-block.deliver-block .block-text {
        background: url(http://www.imaginecommunications.com/Imagine/asset/images/deliver.png) center bottom no-repeat;
    }

    .midabout .color-block1.deliver-block .block-text {
        background: url(http://www.imaginecommunications.com/Imagine/asset/images/deliver.png) center bottom no-repeat;
    }

    .midabout .block-text {
        height: 9em;
        background-position: 50% 50% !important;
    }

        .midabout .block-text a {
            bottom: -3.3em;
            color: #555D93;
            display: block;
            font-size: 0.9em;
            /*amol changes*/
            margin: 0 0.5em;
            /*amol changes*/
            position: absolute;
        }

.about .midabout .block-text a {
    bottom: -4.3em;
}

.midabout .block-title {
    border-bottom: 0.1em solid #FFFFFF;
    color: #FFFFFF;
    display: block;
    font-size: 1.3em;
    margin: 0 0.2em;
    padding: 0.5em 0;
}

.midabout .block-list > li:hover:before {
    background: url("http://www.imaginecommunications.com/Imagine/asset/images/hover-bg.png");
    content: "";
    display: block;
    height: 12em;
    left: 0;
    position: absolute;
    top: 0;
    width: 100%;
}

.about-solutions {
    margin: 0 0 2em;
    overflow: hidden;
}

    .about-solutions li {
        float: left;
        height: 8em;
        margin: 0 25% 0 0;
        padding: 4em 0;
        position: relative;
        width: 25%;
    }

    .about-solutions .tab-box {
        display: block;
        height: 13em;
        padding: 1em 1.5em;
    }

    .about-solutions li {
        list-style: none;
    }

        .about-solutions li:nth-child(1) {
            background: #223d80;
        }

        .about-solutions li:nth-child(2) {
            background: #1768b2;
        }

        .about-solutions li .lrg-txt {
            border-bottom: 0.1em solid #FFFFFF;
            color: #FFFFFF;
            display: block;
            font-size: 1em;
            left: -102%;
            margin: 0 1em;
            padding: 0 0 0.5em;
            position: absolute;
            width: 68%;
        }

    .about-solutions img {
        display: block;
        margin: 3em auto 0;
    }

.about-txt {
    position: absolute;
    right: -94%;
    top: 2em;
    width: 91%;
}

.midabout > ul {
    list-style: disc inside none;
}

    .midabout > ul li {
        list-style: inside;
    }

        .midabout > ul li strong {
            font-weight: normal;
        }

/*Mahadev second 8 March end*/

.content-page p a {
    color: #27A9E1;
}

/*Mahadev Starts 9 March */

/*about Us menu Background menu*/
/* Changes Done by Prashant Starts*/
.about .banner {
    background: none repeat scroll 0 0 #253d7f;
}

.about .nav.top > ul > li:hover {
    background-color: transparent;
}

.about .nav ul li ul li ul {
    background-color: transparent;
}

.about .nav > ul > li > ul > li {
    background-color: transparent;
}
/* Changes Done by Prashant Ends */
.about .banner h1 {
    padding: 0.7em 0 0 !important;
}
/*End about us menu*/
/* Changes Done by Prashant Starts */
.awards .banner {
    background: none repeat scroll 0 0 #243F81;
}

.awards .nav.top > ul > li.active {
    background: transparent url(http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png) repeat;
}

.awards .nav.top > ul > li:hover, .awards .nav ul li ul {
    background-color: transparent;
}
/* Changes Done by Prashant Ends */
.awards .sol-box li a {
    text-align: center;
    font-size: 1em;
    color: #253D7F;
}

.awards .sol-box {
    margin: 0 0 1.5em;
}
/* Changes Done by Prashant starts */
.awards .banner {
    background: none repeat scroll 0 0 #253d7f;
}

.awards .nav.top > ul > li:hover {
    background-color: transparent;
}

.awards .nav ul li ul li ul {
    background-color: transparent;
}

.awards .nav > ul > li > ul > li {
    background-color: transparent;
}
/* Changes Done by Prashant Ends */
.enterprise-education-government .sol-box .imgsol {
    box-shadow: 0.5em 0.5em #97999c;
}

.awards .sol-box li {
    /*background: none repeat scroll 0 0 #FFFFFF;*/
}

    .awards .sol-box li a {
        padding-bottom: .3em;
    }

.sol-box .imgsol {
    /*background: none repeat scroll 0 0 #FFFFFF;*/
}

.imgsol {
    text-align: center;
    vertical-align: central;
    display: block;
}



.innovation .leftpane {
    color: #253D7F;
    line-height: 1.4em;
    font-size: 1em;
}

.innovation .careerstop p {
    width: 52%;
}

.innovation .careerstop > img {
    width: 45%;
}

.innovation .two-columns {
    overflow: hidden;
}

    .innovation .two-columns .column {
        float: right !important;
        margin: 0 1% 2% 0;
    }

.innovation .leftpane h2 {
    font-size: 1em;
    font-weight: bold;
    margin: 0 0 0.3em;
    text-transform: capitalize;
}

.imgsol {
    text-align: center;
    vertical-align: central;
    display: block;
}

.innovation .two-columns .left-text {
    line-height: 1.6em;
}

.column > img {
    width: 97%;
}

.innovation .channel-block {
    margin: 0 !important;
    padding: 0 !important;
}

    .innovation .channel-block img {
        display: block;
    }

.innovation .leftpane .channel-block h2 {
    font-size: 1.4em;
    font-weight: normal;
}

.innovation .block-list {
    background: none repeat scroll 0 0 #F1F1F2;
    overflow: hidden;
    padding: 1.5em;
    width: 100%;
}

    .innovation .block-list > li {
        float: left;
        margin: 0 2% 0 0;
        position: relative;
        width: 23%;
    }

.innovation .tab-box {
    display: block;
    height: 13em;
    padding: 1em 1.5em;
}

.innovation .block-list li:nth-child(1) a {
    background: #223d80;
}

.innovation .block-list li:nth-child(2) a {
    background: #1768b2;
}

.innovation .block-list li:nth-child(3) a {
    background: #8ab4c7;
}

.innovation .block-list li:nth-child(4) a {
    background: #a9a9a9;
}

.innovation .block-list li .link-title {
    border-bottom: 0.1em solid #FFFFFF;
    color: #FFFFFF;
    display: block;
    font-size: 1.7em;
    margin: 0 0 1em;
    padding: 0 0 0.5em;
}

.innovation .block-list li .tab-img {
    display: block;
}

.innovation .block-list .tab-img img {
    margin: 0 auto;
}

.innovation .block-list li:hover:before {
    background: url("http://www.imaginecommunications.com/Imagine/asset/images/hover-bg.png");
    content: "";
    display: block;
    height: 15.8em;
    left: 0;
    position: absolute;
    top: 0;
    width: 100%;
}

.innovation .leftane > * {
    max-width: 62em !important;
}
/*Find reseller */
.find-top {
    background: none repeat scroll 0 0 #F1F1F2;
    color: #58595B;
    font-size: 0.8em;
    margin: 0 0 2em;
    max-width: 60em;
    overflow: hidden;
    padding: 1em;
}

.find-bot table a {
    color: #58595B;
}
/*****************************STW-(10-03-14) _R***********************/
.subpages .leftpane .p1 {
    padding-top: 0px;
}

.work-diagram .two-columns .c2 {
    margin: 0 0 0 6px;
}

    .work-diagram .two-columns .c2 img {
        float: right;
    }

.page-text a.repmail:hover {
    font-weight: bold;
}

/************************** stw vikas(10-3-2014)*/
.tab-box, .block-text { /*amol cahnges for home pages*/
    /*adding-bottom:20px !important;*/
}

/*Mahadev 10 march*/
.find-top {
    background: none repeat scroll 0 0 #F1F1F2;
    color: #58595B;
    font-size: 0.8em;
    margin: 0 0 2em;
    max-width: 60em;
    overflow: hidden;
    padding: 1em;
    float:left;
}

    .find-top ul {
        padding: 1em 0;
        overflow: hidden;
    }

        .find-top ul li {
            overflow: hidden;
            position: relative;
        }

            .find-top ul li label {
                float: left;
                line-height: 2em;
                width: 10em;
            }

            .find-top ul li select {
                background: none repeat scroll 0 0 #FFFFFF;
                border: 0.2em solid #58595B;
                height: 2em;
                position: relative;
                width: 15em;
            }

            .find-top ul li label:before {
                background: url(http://www.imaginecommunications.com/Imagine/asset/images/arrow.png) left top no-repeat;
                content: "";
                height: 1.3em;
                left: 20.4em;
                position: absolute;
                top: 0.3em;
                width: 2em;
                z-index: 1;
            }

.find-bot {
    overflow: hidden;
    position: relative;
    width: 100%;
    font-size: 0.8em;
    color: #58595B;
}

    .find-bot table {
        width: 100%;
        border-spacing: 0;
        border-collapse: collapse;
    }

        .find-bot table .head-data {
            background: none repeat scroll 0 0 #6FB3D3;
            color: #FFFFFF;
        }

            .find-bot table .head-data th {
                border-right: 0.2em solid #6D6F71;
                font-weight: normal;
                padding: 1em 0.5em;
                text-transform: capitalize;
            }

        .find-bot table .list-data td, .find-bot table .list-data th {
            border-bottom: 0.1em solid;
            font-size: 1em;
            font-weight: normal;
            line-height: 1.2em;
            padding: 1em 0;
            text-align: left;
        }
/*Mahdev end 10*/

.learn-box ul li a:hover {
    background-size: 1em auto;
    color: #fff !important;
    font-weight: bold;
}

.products .allContents .channel-block .tab-link p {
    color: #253D7F;
    display: block !important;
    padding: 0;
    margin: 0;
    font-size: 1em !important;
}

.products .allContents .tab-box .block-text {
    padding: 0;
    margin: 0;
}

.channel-block.network-infra span.tab-link {
    /*float: none;*/
}

.channel-block.network-infra span.product-heading {
    /*float: right;
    width: 23em;*/
}

.channel-block.network-infra p {
    float: right;
    width: 42em;
}

#header > .header-inner > div > ul > .CMSListMenuHighlightedLI > .CMSListMenuLinkHighlighted {
    color: #0895D3;
    cursor: pointer;
    font-family: "Myriad Pro",Arial,sans-serif;
    text-decoration: none;
    display: inline-block;
    text-align: center;
    text-transform: uppercase;
    vertical-align: middle;
}

#header > .header-inner > div > ul > .CMSListMenuHighlightedLI:hover > .CMSListMenuLinkHighlighted {
    color: #fff !important;
}
/* Minification failed (line 6781, error number 1043): 'progid:' is an IE-only construct that generates invalid CSS */
/* NAV STARTS */
.LTR .nav.top {
    position: relative;
    margin-left: auto;
    margin-right: auto;
    height: 2em;
    max-width: 80%;
    max-height: 64px;
    top: .7em;
    /* Change By Prashant - start */
    margin-top: 1.9em;
    /* Change By Prashant - end */
    opacity: .95;
    vertical-align: middle;
}

.RTL .nav.top {
    position: relative;
    height: 2em;
    margin-left: auto;
    margin-right: auto;
    max-width: 80%;
    max-height: 64px;
    margin-top: 1.875em;
    background-color: #231f20;
    opacity: .95;
    vertical-align: middle;
    box-shadow: 0 0 .625em #231f20;
    z-index: 1;
}

.nav > ul {
    height: 100%;
}

.nav ul li {
    position: relative;
    list-style: none;
}

    .nav ul li a {
        color: #0895d3;
        text-decoration: none;
        cursor: pointer;
        font-family: "Myriad Pro", Arial, sans-serif;
    }

.nav > ul > li {
    float: left;
    height: 100%;
    font-size: 1.1em;
    text-align: center;
}

    .nav > ul > li > a {
        display: inline-block;
        text-align: center;
        line-height: normal;
        vertical-align: middle;
        text-transform: uppercase;
    }

.nav ul li ul {
    display: none;
    position: absolute;
    min-width: 12.6em;
    max-width: 16.07em;
    line-height: normal;
    text-align: left;
    color: #fff;
    min-height: 7em !important;
}

    .nav ul li ul.media-center {
        min-width: 12.5em;
        max-width: 12.5em;
    }

.LTR .nav ul li ul li a {
    display: block;
    margin: 0 .6em;
    padding: .1em 0;
    color: #fff;
    font-weight: 400 !important;
    font-size: 0.8em;
}

.RTL .nav ul li ul li a {
    display: block;
    margin: 0 .6em;
    padding: .1em 0;
    color: #fff;
    font-weight: 400 !important;
    font-size: 0.8em;
}

.nav ul li ul li:first-child a {
    border-top: none;
}

.nav ul li ul {
    left: 0;
    top: 100%;
    padding-top: .90em;
    /*display: none;
	line-height: normal;
	max-width: 16.07em;
	min-height: 13em !important;
	min-width: 12.6em;
	position: absolute;
	text-align: left;*/
}

.nav.top > ul {
    max-height: 64px;
    line-height: 2em;
}

    .nav.top > ul > li {
        width: 7em;
        max-width: 11.5%;
        max-height: 64px;
        font-family: "Myriad Pro", "Myriad Pro Light", Arial, sans-serif;
    }

    .nav.top > ul > li {
        /*padding:0 5px;*/
        width: 7em;
        max-width: 11.5%;
        max-height: 64px;
        position: relative;
        font-family: "Myriad Pro", "Myriad Pro Light", Arial, sans-serif;
    }

        .nav.top > ul > li + li + li + li + li {
            min-width: 12% !important;
            width: auto !important;
            max-width: 25% !important;
        }

        .nav.top > ul > li:before {
            content: "";
            position: absolute;
            left: 0;
            top: 0.37em;
            width: .1em;
            height: 1.0em;
            background: #b5b5b5;
        }

        .nav.top > ul > li:first-child:before {
            display: none;
        }

        .nav.top > ul > li:hover {
            background: transparent url(http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png) repeat;
            box-shadow: 0 0px 0px #c5c5c5;
        }

            .nav.top > ul > li:hover a {
                color: #fff;
            }

.nav ul li ul li {
    line-height: 1.2em;
    z-index: 2;
}
/* First menu Starts */
.nav ul li ul.first-menu {
    float: left;
    width: 10.9em;
    max-width: 10.9em;
    min-width: 10.9em;
    max-height: 14em;
    min-height: 14em;
}

    .nav ul li ul.first-menu li {
        margin-left: .625em;
        text-align: left !important;
    }

        .nav ul li ul.first-menu li a {
            margin-left: 0px;
        }

        .nav ul li ul.first-menu li.bg {
            background-image: url(http://www.imaginecommunications.com/Imagine/asset/images/creat.png) 0 0 no-repeat;
            position: relative;
            bottom: 0;
            padding-bottom: .09em;
            background-size: 80%;
            top: -.32em;
        }
/* First-Menu Ends */
/* CMSList1 Starts */
.nav ul li ul.CMSList1 {
    float: left;
    width: 10.9em;
    max-width: 10em;
    min-width: 10em;
    /* Change By Prashant - start */
    max-height: 10em !important;
    min-height: 11.7em !important;
    /* Change By Prashant - end */
    /*padding-left:.3em !important*/
}

    .nav ul li ul.CMSList1 li {
        margin-left: .525em;
        text-align: left !important;
    }

        .nav ul li ul.CMSList1 li a {
            margin-left: 0px;
        }

        .nav ul li ul.CMSList1 li.bg {
            /* Change By Prashant - start */
            background: url(http://www.imaginecommunications.com/Imagine/asset/images/creat.png) -0.01em bottom no-repeat;
            /* Change By Prashant - end */
            position: relative;
            bottom: 0;
            padding-bottom: .09em;
            /* Change By Prashant - start */
            background-size: 76%;
            /* Change By Prashant - end */
        }
/* /CMSList1 Ends */

/* Second Menu Starts */

.nav ul li ul.second-menu {
    float: left;
    width: 10.9em;
    max-width: 10.9em;
    min-width: 10.9em;
    max-height: 14em;
    overflow: hidden;
    min-height: 14em;
    left: 10.9em;
}

    .nav ul li ul.second-menu li {
        margin-left: .625em;
        text-align: left !important;
    }

        .nav ul li ul.second-menu li a {
            margin-left: 0px;
        }

        .nav ul li ul.second-menu li.bg {
            background-image: url(http://www.imaginecommunications.com/Imagine/asset/images/deliver.png) 0 0 no-repeat;
            position: relative;
            padding-bottom: .09em;
            background-size: 74%;
            top: -.32em;
        }
/* /Second-menu Ends */
/* CMSList2 Starts */
.nav ul li ul.CMSList2 {
    float: left;
    width: 10.9em;
    max-width: 10em;
    min-width: 10em;
    /* Change By Prashant - start */
    max-height: 10em;
    min-height: 11.7em !important;
    /* Change By Prashant - end */
    left: .3em !important;
}

    .nav ul li ul.CMSList2 li {
        margin-left: .23em;
        text-align: left !important;
    }

        .nav ul li ul.CMSList2 li a {
            margin-left: 0px;
        }

        .nav ul li ul.CMSList2 li.bg {
            /* Change By Prashant - start */
            background: url(http://www.imaginecommunications.com/Imagine/asset/images/deliver.png) -0.01em bottom no-repeat;
            position: relative;
            padding-bottom: .09em;
            background-size: 76%;
            left: 0em;
            bottom: 0;
            /* Change By Prashant - end */
        }
/* /CMSList2 Ends */
/* Third Menu Starts */
.nav ul li ul.third-menu {
    float: left;
    width: 10.9em;
    max-width: 10.9em;
    min-width: 10.9em;
    max-height: 14em;
    min-height: 14em;
    overflow: hidden;
    left: 21.8em;
}

    .nav ul li ul.third-menu li {
        margin-left: .625em;
        text-align: left !important;
    }

        .nav ul li ul.third-menu li a {
            margin-left: 0px;
        }

        .nav ul li ul.third-menu li.bg {
            background-image: url(http://www.imaginecommunications.com/Imagine/asset/images/optimize.png) center bottom no-repeat;
            position: relative;
            padding-bottom: 1.4em;
            background-size: 80%;
            top: -2em;
        }
/* /Third Menu Ends */
/* CMSList3 Starts */
.nav ul li ul.CMSList3 {
    float: left;
    width: 10.9em;
    max-width: 10em;
    min-width: 10em;
    /* Change By Prashant - start */
    max-height: 10em;
    min-height: 11.7em !important;
    left: .3em !important;
    /* Change By Prashant - end */
}

    .nav ul li ul.CMSList3 li {
        margin-left: .23em;
        text-align: left !important;
    }

        .nav ul li ul.CMSList3 li a {
            margin-left: 0px;
        }

        .nav ul li ul.CMSList3 li.bg {
            /* Change By Prashant - start */
            background: url(http://www.imaginecommunications.com/Imagine/asset/images/optimize.png) -0.01em bottom no-repeat;
            position: relative;
            padding-bottom: .09em;
            background-size: 76%;
            left: 0em;
            bottom: 0;
            /* Change By Prashant - end */
        }
/* /CMSList3 Ends */
/* Fourth Starts */
`.nav ul li ul.fourth-menu {
    float: left;
    width: 10.9em;
    max-width: 10.9em;
    min-width: 10.9em;
    max-height: 14em;
    min-height: 14em;
    overflow: hidden;
    left: 32.7em;
}

.nav ul li ul.fourth-menu li {
    margin-left: .625em;
    text-align: left !important;
}

    .nav ul li ul.fourth-menu li a {
        margin-left: 0px;
    }

    .nav ul li ul.fourth-menu li.bg {
        background-image: url(http://www.imaginecommunications.com/Imagine/asset/images/play.png) center bottom no-repeat;
        position: relative;
        padding-bottom: 1.4em;
        background-size: 90%;
        left: -1em;
        top: -2.54em;
    }
/* CMSList4 Starts */
.nav ul li ul.CMSList4 {
    float: left;
    width: 10.9em;
    max-width: 10em;
    min-width: 10em;
    max-height: 14em;
    /* Change By Prashant - start  */
    min-height: 11.7em !important;
    left: .5em !important;
    /* Change By Prashant - end */
}

    .nav ul li ul.CMSList4 li {
        margin-left: .15em;
        text-align: left !important;
    }

        .nav ul li ul.CMSList4 li a {
            margin-left: 0px;
        }

        .nav ul li ul.CMSList4 li.bg {
            /* Change By Prashant - start */
            background: url(http://www.imaginecommunications.com/Imagine/asset/images/play.png) -0.01em bottom no-repeat;
            position: relative;
            padding-bottom: .0em !important;
            background-size: 76%;
            left: 0em;
            bottom: 0;
            /* Change By Prashant - end */
        }
/* /CMSList4 Ends */
/* Sixth Starts */
.nav ul li ul.media-content {
    float: left;
    width: 11.9em;
    max-width: 10.9em;
    min-width: 10.9em;
    min-height: 14.7em;
    max-height: 14.7em;
    overflow: hidden;
    left: 0;
}

    .nav ul li ul.media-content li {
        margin-left: .625em;
        text-align: left !important;
    }

        .nav ul li ul.media-content li a {
            margin-left: 0px;
        }

        .nav ul li ul.media-content li.bg {
            /* Change By Prashant - start */
            background-image: url(http://www.imaginecommunications.com/Imagine/asset/images/playout.png) -0.01em bottom no-repeat;
            /* Change By Prashant - end */
            position: relative;
            padding-bottom: 1.4em;
            background-size: 80%;
            left: 0em;
            /* Change By Prashant - start */
            bottom: 0;
            /* Change By Prashant - end */
        }
/* Sixth Starts */
.nav ul li ul.CMSList6 {
    float: left;
    /* Change By Prashant - start */
    width: 10.9em;
    max-width: 10em;
    min-width: 10em;
    max-height: 14em;
    min-height: 15.3em !important;
    /* Change By Prashant - end */
    left: 0;
}

    .nav ul li ul.CMSList6 li {
        margin-left: .15em;
        text-align: left !important;
    }

        .nav ul li ul.CMSList6 li a {
            margin-left: 0px;
        }

        .nav ul li ul.CMSList6 li.bg {
            /* Change By Prashant - start */
            background: url(http://www.imaginecommunications.com/Imagine/asset/images/playout.png) -0.01em bottom no-repeat;
            position: relative;
            padding-bottom: .0em !important;
            background-size: 76%;
            left: 0em;
            bottom: -.20em !important;
            /* Change By Prashant - end */
        }
/* /CMSList6 Ends */
/* Network InfraStructure STARTS */
.nav ul li ul.network-infra {
    float: left;
    width: 11.2em;
    max-width: 11.2em;
    min-width: 11.2em;
    max-height: 14.7em;
    min-height: 14.7em;
    overflow: hidden;
    left: 10.9em;
}

    .nav ul li ul.network-infra li {
        margin-left: .625em;
        text-align: left !important;
    }

        .nav ul li ul.network-infra li a {
            margin-left: 0px;
        }

        .nav ul li ul.network-infra li.bg {
            background-image: url(http://www.imaginecommunications.com/Imagine/asset/images/networking.png) center bottom no-repeat;
            position: relative;
            padding-bottom: 1.4em;
            background-size: 80%;
            left: 0em;
            top: -1.83em;
        }
/* /Network InfraStructure Ends */
/* CMSList7 Starts */
.nav ul li ul.CMSList7 {
    float: left;
    /* Change By Prashant - start */
    width: 10.9em;
    max-width: 10em;
    min-width: 10em;
    max-height: 14em;
    min-height: 15.5em !important;
    left: 0;
    /* Change By Prashant - end */
}

    .nav ul li ul.CMSList7 li {
        margin-left: .625em;
        text-align: left !important;
    }

        .nav ul li ul.CMSList7 li a {
            margin-left: 0px;
        }

        .nav ul li ul.CMSList7 li.bg {
            /* Change By Prashant - start */
            background: url(http://www.imaginecommunications.com/Imagine/asset/images/networking.png) -0.01em bottom no-repeat;
            position: relative;
            padding-bottom: .0em !important;
            background-size: 76%;
            left: 0em;
            bottom: 0;
            /* Change By Prashant - end */
        }
/* /CMSList7 Ends */
.nav ul li ul.CMSList7 {
    min-height: 11.9em;
    padding-top: 2.6em;
}

.nav ul li ul.CMSList8 li,
.nav ul li ul.CMSList9 li,
.nav ul li ul.CMSList10 li,
.nav ul li ul.CMSList11 li {
    position: relative;
}




.nav > ul > li > ul {
    background: transparent url(http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png) repeat;
    display: none;
    position: absolute;
    min-width: 12.5em;
    max-width: 16.07em;
    line-height: 1.5em;
    text-align: left;
    color: #fff;
    padding-top: .5em;
}
    /* Change by Prashant - start */
    /*body.solutions .nav > ul > li > ul{background:#253D7F none no-repeat !important;}

body.technical-support .nav > ul > li > ul,
body.technical-support .nav > ul > li > ul{background:#253D7F none no-repeat !important;}
body.training .nav > ul > li > ul{background:#0668b3 none no-repeat !important;}


body.enterprise .nav > ul > li > ul{background:#A9A9A9 none no-repeat !important;}
body.professional-services .nav > ul > li > ul{background:#8FBACE none no-repeat !important;}
body.articles .nav > ul > li > ul,
body.enterprise-education-government .nav > ul > li > ul,
body.webinar-series .nav > ul > li > ul,
body.communication-service-providers .nav > ul > li > ul,
body.network-operators .nav > ul > li > ul,
body.tv-broadcasters .nav > ul > li > ul,
body.sports-and-live-events .nav > ul > li > ul,
body.radio-broadcasters .nav > ul > li > ul,
body.network-operators .nav > ul > li > ul,
body.communication-service-providers .nav > ul > li > ul,
body.radio-broadcasters .nav > ul > li > ul,
body.media-resources .nav > ul > li > ul{background:#A9A9A9 none no-repeat !important;}

body.agreements .nav > ul > li > ul{background:#243f81 none no-repeat !important;}


span.CMSListMenuLinkHighlighted{margin: 0 0.45em !important}
.innovation .nav.top > ul > li.active a{color:#fff !important}*/
    /* Change by Prashant - end */
    .nav > ul > li > ul > li {
        float: none !important;
    }

.nav ul li ul:before {
    content: "";
    display: block;
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: auto;
    overflow: hidden;
    opacity: 0;
}

.LTR .nav ul li ul li ul {
    /*padding-left: 0.43em;*/
    padding-top: 1.5em;
    top: 0;
    width: 9em;
    /*background: transparent url(http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png) 0 0 repeat;*/
    min-height: 4em;
}

.nav ul li ul li ul:before {
    top: 0;
    left: 0;
    width: .43em;
    height: auto !important;
    max-height: 100%;
}


.nav ul li ul li,
.nav ul li ul li a {
    color: #fff !important;
}


.bg {
    bottom: 0 !important;
    height: 5em !important;
    left: 0;
    position: absolute !important;
    width: 12em !important;
    z-index: 1 !important;
}

.nav ul li ul.CMSListMenuUL.CMSList0 {
    max-width: 40em !important;
    width: 52em !important;
    /* Change By Prashant - start */
    height: auto !important;
    /* Change By Prashant - end */
    min-height: 13.1em !important;
}

    .nav ul li ul.CMSListMenuUL.CMSList0 li {
        width: 10em !important;
        float: left !important;
    }

.nav ul li ul.CMSListMenuUL.CMSList5 {
    max-width: 21em !important;
    width: 21em !important;
    /* Change By Prashant - start */
    height: auto !important;
    min-height: 17em !important;
    /* Change By Prashant - end */
}

    .nav ul li ul.CMSListMenuUL.CMSList5 li {
        width: 10em !important;
        float: left !important;
    }
        /* Change By Prashant - start */
        .nav ul li ul.CMSListMenuUL.CMSList5 li ul {
            top: .01em;
            margin-left: .5em;
        }

        .nav ul li ul.CMSListMenuUL.CMSList5 li + li ul {
            top: .01em;
            margin-left: .0em;
        }

        .nav ul li ul.CMSListMenuUL.CMSList5 li + li.CMSListMenuLI.parent.parentul a {
            text-indent: 0.15em !important;
        }

        .nav ul li ul.CMSListMenuUL.CMSList5 li + li.CMSListMenuLI.parent.parentul ul li a {
            text-indent: 0;
        }

.nav ul li + li + li ul.CMSList8 {
    min-height: 12em !important;
}

.nav ul li + li + li + li ul.CMSList9 {
    left: -5.58em;
    min-height: 12em !important;
}

.nav ul li + li + li + li + li ul.CMSList10 {
    min-width: 100% !important;
    width: 100% !important;
    max-width: 100% !important;
    overflow: hidden !important;
    min-height: 12em !important;
    max-height: 12em;
}

.nav ul li + li + li + li + li + li ul.CMSList11 {
    left: -5.28em;
    min-height: 12em !important;
}

.nav ul li + li + li ul.CMSList8 li span.CMSListMenuLinkHighlighted,
.nav ul li + li + li ul.CMSList9 li span.CMSListMenuLinkHighlighted,
.nav ul li + li + li ul.CMSList10 li span.CMSListMenuLinkHighlighted,
.nav ul li + li + li ul.CMSList11 li span.CMSListMenuLinkHighlighted {
    margin: 0 0.6em !important;
    display: block !important;
    font-size: 0.9em !important;
}

/*span.CMSListMenuLinkHighlighted{margin: 0 0.45em !important; font-weight:bold !important}*/

li.active {
    background: transparent url(http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png) 0 0 repeat !important;
}

    li.active a,
    li.active span { /*margin: 0 0.45em !important; font-weight:bold !important;*/
        color: #fff !important;
    }
/* Change By Prashant - end */
@media screen and (-webkit-min-device-pixel-ratio:0) {
    .nav ul li + li + li + li ul.CMSList9 {
        left: -5.7em !important;
    }

    .nav ul li + li + li + li + li + li ul.CMSList11 {
        left: -5.36em;
    }
    /* Safari only override */
    ::i-block-chrome, .nav.top > ul {
        line-height: 2.2em !important;
    }

    ::i-block-chrome, #header > .header-inner > div > ul > .CMSListMenuHighlightedLI > .CMSListMenuLinkHighlighted {
        vertical-align: inherit !important;
        line-height: 1.4em !important;
        top: -.2em;
        position: relative;
    }

    ::i-block-chrome, .nav.top > ul > li + li + li + li + li {
        min-width: 12% !important;
    }

    ::i-block-chrome, .nav ul li + li + li + li + li + li ul.CMSList11 {
        left: -5.26em;
    }
}
/* Our changes */

.nab .leftpane .nab-text .sol-box li:hover .blu-div {
    display: block;
}

table.contenttable td:hover tr:first-child td:before { /*:hover*/
    background: url("http://www.imaginecommunications.com/Imagine/asset/images/tr-img.png") repeat scroll left top rgba(0, 0, 0, 0);
    content: "";
    display: block;
    height: 7.7em;
    position: absolute;
    width: 25.3%;
}

table.contenttable td:hover tr a {
    font-weight: bold !important;
}

.internal-banner {
    overflow: hidden;
}

.careerstop a.carousel-button:hover {
    font-weight: bold;
}

.form-section .form-required {
    margin-right: -1em;
    padding-left: 0.5em;
}

.form-buttons-wrapper .FormButton {
    background: none repeat scroll 0 0 #0C95D3;
    border: medium none;
    color: #FFFFFF;
    cursor: pointer;
    display: block;
    float: left;
    font-size: 1.1em;
    margin: 0 0.5em 0 0;
    padding: 0.2em 0.5em;
}

.CheckBoxListField label, .RadioButtonList label {
    padding-left: 0.3em;
}

.leftpane .producthead {
    text-transform: uppercase;
}

/* nav Ends */
#footer {
    background-color: #FFFFFF;
    height: 4.6875em;
    max-height: 75px;
    width: 100%;
}

.sup-footer {
    /*background: none repeat scroll 0 0 #404041 !important;*/
    color: #FFFFFF;
    height: auto !important;
    max-height: inherit !important;
    overflow: hidden;
    position: relative !important;
    /*width: 100%;*/
}

.inner {
    box-shadow: 0 0 2em #000000 inset;
    margin: auto;
    /*padding: 1em 0;*/
    padding: 1% 10%;
    position: relative;
    /*width: 84.04%;*/
    width: 80%;
    background: none repeat scroll 0 0 #404041 !important;
    z-index: 1;
    font-size: 0.9em;
}

.list-foot {
    overflow: hidden;
    position: relative;
    width: 100%;
}

.sup-footer p {
    margin: 1em 0;
    text-align: center;
}

.policy {
    display: table;
    margin: 0 auto;
}

ul, li {
    list-style: none outside none;
}

.policy > li {
    color: #FFFFFF;
    float: left;
    list-style: disc inside none;
    margin: 0 0.4em;
}

.list-foot ul li:first-child {
    list-style: none outside none;
}

.list-foot ul li {
    color: #29AAE2;
    /*list-style: disc inside none;*/
    width: 10em;
}

.list-foot ul {
    float: left;
    width: 13%;
}

    .list-foot ul li a {
        color: #29AAE2;
    }

.sup-footer p {
    margin: 1em 0;
    text-align: center;
}

.policy > li a {
    color: #FFFFFF;
}

.LegalandCompliance .banner, .LegalandCompliance .nav.top > ul > li:hover {
    background: none repeat scroll 0 0 #A9A9A9;
}

.list-foot #topFooter li {
    list-style: disc inside none;
}

.list-foot ul li:hover {
    font-weight: bold;
    /*width: 11em;*/
}

/*Search Start*/
.st-search-summary {
    border-bottom: 1px solid #ccc;
    padding-bottom: 7px;
    margin: 12px 0;
}

.st-result-listing {
    width: 100%;
}

.st-search-summary h2 {
    font-size: 13px;
    font-weight: normal;
    color: #333;
    margin: 0;
}

.st-result {
    border-bottom: 1px solid #ddd;
    padding-bottom: 12px;
    margin-bottom: 12px;
}

.st-result-text h3 {
    font-size: 12px !important;
    margin: 5px 0;
}

.st-result h3 {
    font-size: 12px;
    margin: 5px 0;
}

    .st-result h3 a {
        color: #0065b3;
    }

.st-pagination {
    border-top: 1px solid #ccc;
    margin-top: 5px;
    padding-top: 5px;
}

    .st-pagination a {
        margin-right: 20px;
    }
/*Search End*/

#footerNavigation {
    width: 70em;
}

.bottom-nav li span {
    color: #A8A8A8;
    float: left;
    font-size: 1em;
    padding-right: 0.5em;
    line-height: 2em;
}


.jcarousel-skin-tango {
    float: left;
    width: 19em;
}

    .jcarousel-skin-tango .jcarousel-container-horizontal {
        width: 18em;
    }

    .jcarousel-skin-tango .jcarousel-clip-horizontal {
        height: 2em;
        width: 18em;
        margin-left: 0.6em;
        overflow: hidden;
    }

    .jcarousel-skin-tango .jcarousel-item {
        font-size: 0.9em;
        height: 2em;
        margin: 0;
        width: 18em;
        overflow: hidden;
    }

        .jcarousel-skin-tango .jcarousel-item a {
            display: block;
            line-height: 2em;
            color: #63676A;
        }

    .jcarousel-skin-tango .jcarousel-prev-horizontal {
        /*background: url("http://www.imaginecommunications.com/Imagine/asset/images/left-arrow.png") no-repeat left top;*/
        cursor: pointer;
        height: 3em;
        left: -0.9em;
        position: absolute;
        top: 0;
        width: 2em;
    }

    .jcarousel-skin-tango .jcarousel-next-horizontal {
        /*background: url("http://www.imaginecommunications.com/Imagine/asset/images/right-arrow.png") no-repeat left top;*/
        cursor: pointer;
        height: 3em;
        position: absolute;
        right: -1.9em;
        top: 0;
        width: 2em;
    }

/*Media Center*/
#home > div.homepage-block-container > div.color-block > a > span {
    font-size: 1.2em;
    font-weight: normal;
}

#home > div.homepage-block-container > div.color-block.create-block > div {
    font-size: 0.8em;
}

#home > div.homepage-block-container > div.color-block.optimize-block > div {
    font-size: 0.8em;
}

#home > div.homepage-block-container > div.color-block.play-block > div {
    font-size: 0.8em;
}

#home > div.homepage-block-container > div.color-block.deliver-block > div > ul > li > a {
    font-size: 0.8em;
}
/*end Media Center*/
/*Market start*/
#home > div.market-page.services > div > div > span > a > span {
    font-size: 0.9em !important;
    height: 3em;
}


.nab-text .sol-box {
    /*Changed by Mahadev due to font is not getting visible on the background */
    background: none repeat scroll 0 0 #CCCCCC; /*background: #F1F1F2;#A9A9A9*/
}
/*Services changes By 15 March 2014*/
.services .market-page.services {
    bottom: 0;
}

.services .solutions-box {
    overflow: hidden;
}



    .services .solutions-box span.tab-img span.content {
        border-top: .10em solid #fff !important;
        font-size: .6em;
        color: #fff;
        display: block;
        min-height: 4.6em;
    }


    .services .solutions-box .tab-img-last img {
        display: block !important;
        margin: 1.8em 0 1em !important;
        width: 100% !important;
        height: 9em;
    }

div.market-page.services > div {
    min-height: 20em;
    max-height: 20em;
}

#home > div.market-page.services > div > div > span > a > span.content {
    min-height: 4.6em;
}

/*div.market-page.services > div:nth-child(3) > span.tab-img.tab-img-last > a > img
    {
        padding-top: 1.2em;
        *margin-top:0.6em !important;
    }

    div.market-page.services > div:nth-child(2) > span.tab-img.tab-img-last > a > img
    {
        padding-top: 2.4em;
    }

    div.market-page.services > div:nth-child(1) > span.tab-img.tab-img-last > a > img
    {
        padding-top: 2.4em;
    }*/
/*Set css for Bug 3996 STW kiran*/

body {
    background: #404041;
}

.nav ul li a {
    font-size: 1em;
}

.contact-us, .customer-login {
    font-size: 0.9em;
}

.search-block {
    max-width: 15%;
    width: auto;
}

.inner {
    box-shadow: 0 0.5em 0.5em #1d1d1d inset;
}

#footer .footer-inner {
    overflow: hidden;
    padding: 1.5em 0;
}

.footer-inner .copyrights {
    width: 17%;
    display: none;
}

.bottom-nav {
    width: 65%;
    margin-left: 0;
    float: left;
}

#footerNavigation {
    width: 100%;
}

.bottom-nav li {
    float: left;
    width: 48%;
}

    .bottom-nav li span {
        width: 17%;
    }

.jcarousel-skin-tango {
    width: 78%;
}

    .jcarousel-skin-tango .jcarousel-prev-horizontal, .jcarousel-skin-tango .jcarousel-next-horizontal {
        background-size: 100%;
    }

    .jcarousel-skin-tango .jcarousel-container-horizontal {
        width: 100%;
    }

.allContents .tab-img {
    width: 20%;
}

.create .allContents .channel-block .solutionContent > .tab-box {
    width: 77%;
}

.create .allContents .channel-block .solutionContent p {
    width: 77%;
}

.banner > img {
    height: 6em;
}

.sfimageWrp img {
    max-width: 100%;
}

.video-box a > div, .video-box > * {
    height: auto !important;
    width: auto !important;
}

.video-area {
    overflow: hidden;
}

    .video-area .video-box {
        float: right;
        width: 42%;
    }

    .video-area .text {
        float: left;
        width: 55%;
    }

.video-box > div img {
    max-width: 100%;
}

.video-box > div {
    float: none;
}

.homepage-block-container.solu.solution .color-block {
    height: 14em;
}

.homepage-block-container.solu.solution .block-text {
    background-position: 50% 76%;
    background-size: 87% auto !important;
    height: 196px !important;
    padding: 0;
    font-weight: 700;
    font-size: 0.8em!important;
}

.homepage-block-container.solu.solution .channel-block .solutionContent {
    margin: 0;
}

    .homepage-block-container.solu.solution .channel-block .solutionContent .full-box {
        float: none;
    }

.solution-dtsl .product-info.inline-box {
    display: none;
}
/*Set css for Bug 3996 STW kiran*/

body {
    background: #404041;
}

.nav ul li a {
    font-size: 1em;
}

.contact-us, .customer-login {
    font-size: 0.9em;
}

.search-block {
    max-width: 19%;
    width: auto;
}

.inner {
    box-shadow: 0 0.5em 0.5em #1d1d1d inset;
}

#footer .footer-inner {
    overflow: hidden;
    padding: 1.5em 0;
}

.footer-inner .copyrights {
    width: 17%;
}

.bottom-nav {
    width: 69%;
    margin-left: 0;
    float: left;
}

#footerNavigation {
    width: 100%;
}

.bottom-nav li {
    float: left;
    padding: 0;
    width: 50%;
}

    .bottom-nav li span {
        width: 17%;
    }

.jcarousel-skin-tango {
    width: 78%;
}

    .jcarousel-skin-tango .jcarousel-prev-horizontal, .jcarousel-skin-tango .jcarousel-next-horizontal {
        background-size: 100%;
    }

    .jcarousel-skin-tango .jcarousel-container-horizontal {
        width: 100%;
    }

.allContents .tab-img {
    width: 20%;
}

.create .allContents .channel-block .solutionContent > .tab-box {
    width: 77%;
    max-width: inherit;
}

.create .allContents .channel-block .solutionContent p {
    width: 77%;
}

.banner > img {
    height: 6em;
}

.sfimageWrp img {
    max-width: 100%;
}

.video-box a > div, .video-box > * {
    height: auto !important;
    width: auto !important;
}

.video-area {
    overflow: hidden;
}

    .video-area .video-box {
        float: right;
        width: 42%;
    }

    .video-area .text {
        float: left;
        width: 55%;
    }

.video-box > div img {
    max-width: 100%;
}

.video-box > div {
    float: none;
}

.network-operators .bottompane {
    width: 74.5%;
}

.twitter-img > img {
    max-width: 100%;
}

.media .optimize-block img {
    margin: 0.5em 0 0;
    max-width: 100%;
}

.events .page-text > a {
    width: 17%;
}

.events .page-text img {
    width: 100%;
}

.events .page-text > .text {
    padding: 0 1% 2%;
    width: 46%;
}

.events .page-text li img {
    width: 17%;
}

.webn-top > img {
    max-width: 100%;
    width: 43%;
}

.webn-mid img {
    width: 100%;
}

.webn-mid .column {
    width: 46% !important;
    padding: 1em 2% 0 0;
}

/* end Set css for Bug 3996 STW kiran*/
/*16 march*/
.sfContentBlock {
    max-width: 62em;
}

    .sfContentBlock table {
        width: 100% !important;
    }

.webn-mid img {
    height: auto;
}

.about .careerstop .desc {
    width: 40%;
}

.about .careerstop .popup-vimeo {
    float: right;
    width: 55%;
}

    .about .careerstop .popup-vimeo img {
        max-width: 100%;
    }

.midabout .block-text {
    background-size: 80% !important;
}

.about-solutions li {
    list-style: none !important;
}

.about-solutions img {
    max-width: 100%;
}

.careerstop > img {
    width: 43%;
}

.innovation .block-list .tab-img img {
    max-width: 100%;
}

.forimg {
    width: 19%;
}

.portfolio li img, .nab-text .photo img, .internal-banner img, table.contenttable td tr td img {
    max-width: 100%;
}

.test-top .portfolio li h3, .test-top .portfolio li p, .test-top .portfolio li .smaller {
    width: 77%;
    float: left;
}

.nab-text .photo {
    width: 25%;
    overflow: hidden;
}

.sfContentBlock table td strong, .sfContentBlock table td span {
    font-size: 1.4em !important;
}

table.contenttable td tr td {
    width: 85% !important;
}

.sol-box .imgsol {
    width: 100%;
}

.jcarousel-skin-tango .jcarousel-clip-horizontal {
    width: 98%;
}

.jcarousel-skin-tango .jcarousel-item {
    width: 25em;
}

.about .careerstop > a {
    float: right;
    width: 45%;
}

.about .careerstop img {
    max-width: 100%;
    height: auto !important;
}

.about .careerstop .desc {
    width: 55%;
}

.midabout .contentblog > li {
    float: left;
    height: 9em;
    margin: 0 25% 0 0;
    padding: 4em 0;
    position: relative;
    width: 25%;
    cursor: pointer;
}

.midabout .contentblog li img {
    display: block;
    margin: 3em auto 0;
}

.midabout .contentblog li .block-text {
    position: absolute;
    right: -94%;
    top: 2em;
    width: 91%;
}

.contentblog li .create-block {
    height: 8em;
}

.midabout .color-block1.create-block .block-text {
    background: url(http://www.imaginecommunications.com/Imagine/asset/images/creat.png) center bottom no-repeat;
}

.contentblog li:nth-child(1) {
    background: none repeat scroll 0 0 #223D80;
}

.contentblog li:nth-child(2) {
    background: none repeat scroll 0 0 #1768B2;
}

.contentblog .color-block1.create-block {
    background: none;
}


.contentblog .lrg-txt {
    border-bottom: 0.1em solid #FFFFFF;
    color: #FFFFFF;
    display: block;
    font-size: 0.7em;
    left: 0;
    margin: 3em 3.5em;
    position: absolute;
    top: 0;
    width: 60%;
}

    .contentblog .lrg-txt .block-title {
        border: none;
    }


.midabout .contentblog li img {
    display: block;
    margin: 2em auto 0;
    max-width: 100%;
    width: 85%;
}


.midabout .contentblog > li:hover:before {
    background: none;
}

.imagine-academy .headerImage > img {
    bottom: -3.30em;
    height: 10.9em!important;
    width: 26%!important;
    position: absolute;
    right: 0;
}

.imagine-academy .banner {
    background: #0668b3;
}

#footerNavigation .HomepageBlog,#footerNavigation .HomepageNews {
    display: none;
}



/*Set css for Solution-Optimize*/
.optimize .allContents .channel-block .solutionContent > .tab-box {
    max-width: inherit;
    width: 77%;
}

.optimize .solutionContent .tab-box .tab-link {
    font-size: 0.8em;
}


.optimize .allContents .tab-box .tab-link span {
    font-size: 1.3em;
}

.optimize .allContents .channel-block .solutionContent p {
    width: 77%;
}

.optimize .solutionContent p > a, .create .allContents .channel-block .solutionContent p .tab-box.sm-box {
    margin: 0 !important;
}

.optimize .solutionContent .tab-box .tab-link {
    font-size: 0.8em;
}

.optimize .solutionContent {
    margin: 0 0 1em;
    overflow: hidden;
}



/*Set css for Solution-Play*/


.play .allContents .channel-block .solutionContent > .tab-box {
    max-width: inherit;
    width: 77%;
}

.play .solutionContent .tab-box .tab-link {
    font-size: 0.8em;
}


.play .allContents .tab-box .tab-link span {
    font-size: 1.3em;
}

.play .allContents .channel-block .solutionContent p {
    width: 77%;
}

.play .solutionContent p > a, .create .allContents .channel-block .solutionContent p .tab-box.sm-box {
    margin: 0 !important;
}

.play .solutionContent .tab-box .tab-link {
    font-size: 0.8em;
}

.play .solutionContent {
    margin: 0 0 1em;
    overflow: hidden;
}

.media .play-block {
    display: none !important;
}

.media .deliver-block {
    left: 41.5% !important;
}

.media .block-text {
    height: 296px !important;
    display: block !important;
    background-size: auto !important;
}
/*Search Template Height*/
.searchClass {
    height: auto !important;
}

.social-networks li.one-publication {
    display: none;
}
/*Prashant*/

.markets .market-page .solutions-box {
    position: absolute;
    bottom: 0;
    width: 17.6%;
    height: auto;
    padding: 0 !important;
    margin: 0 !important;
    opacity: .95;
    color: #fff;
    min-height: 17em;
    max-height: 17em;
    /*box-shadow: 1px 2px .625em #231f20*/
}

    .markets .market-page .solutions-box .tab-img-txt {
        width: 94%;
        margin: 0 auto !important;
        display: block;
        padding: .4em 0 0 0;
        min-height: 2.8em;
    }


.markets #home.image-container {
    height: 100% !important;
    max-height: 50em !important;
}
/*Set css for Nab page */
.nab .sol-box li {
    float: left;
    height: 220px;
    margin: 0 0 0.9em 2.3%;
    position: relative;
    width: 22%;
}

.nab .sol-box .tab-img img {
    border: 1em solid #FFFFFF;
    display: block;
    height: 8em !important;
    width: 70% !important;
}

.nab .sol-box .imgsol {
    border: 1em solid #FFFFFF;
    height: 6em;
    width: auto !important;
}


    .nab .sol-box .imgsol img {
        height: 6em !important;
        width: 100% !important;
    }

.nab .blu-div {
    height: 8em;
    width: 7.8em;
}

.nab .sfContentBlock table {
    width: inherit !important;
}


/* Minification failed (line 7322, error number 1019): Unexpected token, found '`' */