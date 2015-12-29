//
//  Test.m
//  Test
//
//  Created by TangJR on 11/29/15.
//  Copyright © 2015 tangjr. All rights reserved.
//

#import "MC.h"

static MC result = {0, 0};

double getRange(double cf, double ce, double t) {
    if (ce != 0) {
        cf = cf > ce ? cf : ce;
    }
    if (t != 0) {
        cf = cf > t ? t : cf;
    }
    return cf;
}

double getLoop(double cf, double ce, double t) {
    while (cf > t) {
        cf -= t - ce;
    }
    while (cf < ce) {
        cf += t - ce;
    }
    return cf;
}

void convertor(double longitude, double latitude, double *cg) {
    if (!cg) {
        return;
    }
    double t = cg[0] + cg[1] * longitude;
    double ce = ABS(latitude) / cg[9];
    double ch = cg[2] + cg[3] * ce + cg[4] * pow(ce, 2) + cg[5] * pow(ce, 3) + cg[6] * pow(ce, 4) + cg[7] * pow(ce, 5) + cg[8] * pow(ce, 6);
    t *= (longitude < 0 ? -1 : 1);
    ch *= (latitude < 0 ? -1 : 1);
    result.x = round(t * 100) / 100;
    result.y = round(ch * 100) / 100;
}

MC convertLL2MC(double longitude, double latitude) {
    int LLBAND[] = {75, 60, 45, 30, 15, 0};
    double LL2MC[][10] = {{-0.0015702102444, 111320.7020616939, 1704480524535203, -10338987376042340, 26112667856603880, -35149669176653700, 26595700718403920, -10725012454188240, 1800819912950474, 82.5},
        {0.0008277824516172526, 111320.7020463578, 647795574.6671607, -4082003173.641316, 10774905663.51142, -15171875531.51559, 12053065338.62167,  -5124939663.577472, 913311935.9512032, 67.5},
        {0.00337398766765, 111320.7020202162, 4481351.045890365, -23393751.19931662, 79682215.47186455, -115964993.2797253, 97236711.15602145, -43661946.33752821, 8477230.501135234, 52.5},
        {0.00220636496208, 111320.7020209128, 51751.86112841131, 3796837.749470245, 992013.7397791013, -1221952.21711287, 1340652.697009075, -620943.6990984312, 144416.9293806241, 37.5},
        {-0.0003441963504368392, 111320.7020576856, 278.2353980772752, 2485758.690035394, 6070.750963243378, 54821.18345352118, 9540.606633304236, -2710.55326746645, 1405.483844121726, 22.5},
        {-0.0003218135878613132, 111320.7020701615, 0.00369383431289, 823725.6402795718, 0.46104986909093, 2351.343141331292, 1.58060784298199, 8.77738589078284, 0.37238884252424, 7.45}
    };
    longitude = getLoop(longitude, -180, 180);
    latitude = getRange(latitude, -74, 74);
    
    int countLLBAND = sizeof(LLBAND) / sizeof(int);
    double *cg = NULL;
    for (int cf = 0; cf < countLLBAND; cf++) {
        if (latitude >= LLBAND[cf]) {
            cg = LL2MC[cf];
            break;
        }
    }
    if (!cg) {
        for (int cf = countLLBAND - 1; cf >= 0; cf--) {
            if (longitude <= -LLBAND[cf]) {
                cg = LL2MC[cf];
                break;
            }
        }
    }
    
    convertor(longitude, latitude, cg);
    return result;
}