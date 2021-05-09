/* See LICENSE file for copyright and license details. */

/* appearance */

// 161616 - black
// 373438 - gray
static const unsigned int borderpx  = 3; //4    /* border pixel of windows */
static const unsigned int snap      = 20;//34   /* snap pixel */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const int focusonwheel       = 0;
static const char *fonts[]          = { "monospace:size=15" };
static const char dmenufont[]       = "monospace:size=15";

static const char col_black[]       = "#000000";
static const char col_gray[]        = "#1e2330"; // #282a36 #1e2330 
static const char col_white[]       = "#c6a9a5"; 
static const char col_urgborder[]   = "#FF0000";

//  [SchemeNorm] = { font_color, bar_inactive, col_white },
//	[SchemeSel]  = { font_color, bar_active, col_white },
//	[SchemeUrg]  = { font_color, bar_urgent, col_urgborder },

static const char *colors[][3]      = {
	/*               fg         bg         border   */
	[SchemeNorm] = { col_white, col_black, col_black },
	[SchemeSel]  = { col_white, col_gray, col_gray },
	[SchemeUrg]  = { col_white, col_black, col_urgborder },
};

/* tagging */
static const char *tags[] = { "", "", "", "", "", "", "", "", "" }; //

/* alternative tags */
static const char *tagsalt[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }; //

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class       instance    title       tags mask     isfloating   monitor */
	{ "Gimp",      NULL,       NULL,       0,            1,           -1 },
	{ "firefox",   NULL,       NULL,       1 << 0,       0,           -1 },
	{ "spot",      NULL,       NULL,       1 << 5,       0,           -1 },
	{ "discord",   NULL,       NULL,       1 << 4,       0,           -1 },
    { "stalonetray", NULL,     NULL,       1 << 8,       1,           -1 },
	//{ "KeePassXC", NULL,       NULL,       1 << 8,       1,           -1 },
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */

static const Layout layouts[] = {
	/* symbol     arrange function */
    { "[]=",      tile }, /* first entry is default */   
	{ "[M]",      monocle },
	{ "><>",      NULL },    /* no layout function means floating behavior */
    { "|M|",      centeredmaster },
	{ ">M>",      centeredfloatingmaster },
	{ "[D]",      deck },
	{ "DD",       doubledeck },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_gray, "-nf", col_white, "-sb", col_black, "-sf", col_white, NULL };
static const char *termcmd[]  = { "kitty", NULL };
static const char *i3lock[]   = { "i3lock", "-i", "/home/kitty/Pictures/open-sourcerer-3440×1440.png", "-e", "-f", NULL };
static const char *volumep[]  = { "pulsemixer", "--id", "1", "--change-volume", "+2", NULL };
static const char *volumem[]  = { "pulsemixer", "--id", "1", "--change-volume", "-2", NULL }; 
static const char *scrot[]    = { "scrot", "/home/kitty/Pictures/Scrot/S_%d_%m_%Y_%H:%M:%S", NULL };
static const char *lydv[]    = { "setxkbmap", "dvorak", NULL };
static const char *lydvp[]   = { "setxkbmap", "-layout", "us", "-variant", "dvp", NULL };
static const char *lych[]    = { "setxkbmap", "ch", NULL };

//#include "push.c"
static Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY,                       XK_e,      spawn,          {.v = dmenucmd } },
	{ MODKEY,                       XK_Return, spawn,          {.v = termcmd } },
	{ MODKEY|ShiftMask,             XK_n,      spawn,          {.v = i3lock } },
	{ MODKEY,                       XK_F11,    spawn,          {.v = volumep } },
	{ MODKEY,                       XK_F10,    spawn,          {.v = volumem } },
	{ MODKEY,                       XK_F1,     spawn,          {.v = scrot } },
    { MODKEY,                       XK_F2,     spawn,          {.v = lych } },
    { MODKEY,                       XK_F3,     spawn,          {.v = lydv } },
    { MODKEY,                       XK_F4,     spawn,          {.v = lydvp } },
	{ MODKEY,                       XK_l,      togglebar,      {0} },
	{ MODKEY,                       XK_h,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_t,      focusstack,     {.i = -1 } },
	{ MODKEY|ControlMask,           XK_h,      pushdown,       {0} },
    { MODKEY|ControlMask,           XK_t,      pushup,         {0} },	
	{ MODKEY,                       XK_c,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_g,      incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_d,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_n,      setmfact,       {.f = +0.05} },
	{ MODKEY|ShiftMask,             XK_Return, zoom,           {0} },
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY|ShiftMask,             XK_j,      killclient,     {0} },
	{ MODKEY,                       XK_y,      setlayout,      {.v = &layouts[0]} }, /* tiled */
	{ MODKEY,                       XK_u,      setlayout,      {.v = &layouts[2]} }, /* monocle */
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[1]} }, /* floating */
	{ MODKEY,                       XK_r,      setlayout,      {.v = &layouts[3]} }, /* centered master */
	{ MODKEY|ShiftMask,             XK_r,      setlayout,      {.v = &layouts[4]} }, /* centered floating master */
	{ MODKEY,                       XK_p,      setlayout,      {.v = &layouts[5]} }, /* deck */
	{ MODKEY|ShiftMask,             XK_p,      setlayout,      {.v = &layouts[6]} }, /* double deck */
	{ MODKEY,                       XK_space,  setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
	{ MODKEY,                       XK_b,      togglealttag,   {0} },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	{ MODKEY|ShiftMask,             XK_Escape,      quit,           {0} },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[1]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

