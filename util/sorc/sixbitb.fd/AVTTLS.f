      SUBROUTINE AVTTLS(ISLOTA,ISLOTB,IPANA,INSET,IRLAB,JX2,INCR)
C$$$  SUBPROGRAM DOCUMENTATION BLOCK
C                .      .    .                                       .
C SUBPROGRAM:    AVTTLS      INPUT FIELD READER
C   PRGMMR: KUMAR            ORG: W/NP12   DATE: 1999-12-21
C
C ABSTRACT: WRITES VARIAN TITLE, FRON AND REAR STRIP (FAX) TITLES
C   FOR 1 AND 2 PANEL CHARTS...USES BASIC TITLE INFO GENERATED BY
C   PREVIOUS CALL TO DOFRST...DESIGNED FOR INTERNATIONAL AVIATION
C   PACKAGE PROGRAMS AVPOLAR AND AVMERC ONLY...MUST BE CALLED IN
C   SLOT LOOP.
C
C PROGRAM HISTORY LOG:
C   84-08-??  KEVIN HLYWIAK
C   85-12-??  DOUG MILLER, MODIFIED ROUTINE TO ADD DUCK TO THE FAX AND
C             VARIAN CHARTS.
C   91-02-21  LILLY MODIFIED ROUTINE AND ADDED DOC BLOCK.
C   95-05-05  LILLY CONVRT SUBROUTINE TO FORTRAN 77. ALSO,
C             ADD THE ISCHEDS TO DO THE ATLANTIC AND PACIFIC
C             FAX CUTS.
C 1999-11-08  CONVERTED FROM CRAY TO IBM SP/6000
C
C USAGE:    CALL AVTTLS(ISLOTA,ISLOTB,IPANA,INSET,IRLAB,JX2,INCR)
C   INPUT ARGUMENT LIST:
C     ISLOTA   - FIRST 4 CHARACTER OF FAX/VARIAN SLOT NUMBER.
C     ISLOTB   - THE 5TH CHARACTER OF FAX/VARIAN SLOT NUMBER.
C     IPANA    - FIRST 4 CHARACTER OF PANEL PART OR REAL INSET PART
C     INSET    - THE INSET NUMBER.
C     IRLAB    - REAR LABEL INSET NUMBER.
C
C   OUTPUT ARGUMENT LIST:      (INCLUDING WORK ARRAYS)
C     WRKARG   - GENERIC DESCRIPTION, ETC., AS ABOVE.
C     OUTARG1  - EXPLAIN COMPLETELY IF ERROR RETURN
C     ERRFLAG  - EVEN IF MANY LINES ARE NEEDED
C
C   INPUT FILES:   (DELETE IF NO INPUT FILES IN SUBPROGRAM)
C     DDNAME1  - GENERIC NAME & CONTENT
C
C   OUTPUT FILES:  (DELETE IF NO OUTPUT FILES IN SUBPROGRAM)
C     DDNAME2  - GENERIC NAME & CONTENT AS ABOVE
C     FT06F001 - INCLUDE IF ANY PRINTOUT
C
C REMARKS: LIST CAVEATS, OTHER HELPFUL HINTS OR INFORMATION
C
C ATTRIBUTES:
C   LANGUAGE: F90      
C   MACHINE:  IBM
C
C$$$
C
C   KEVIN HLYWIAK     AUG 1984
C   DOUG MILLER       DEC 1985-DUCK ADDED TO FAX AND VARIAN CHARTS
C   WRITES VARIAN TITLE, FRONT AND REAR STRIP (FAX) TITLES FOR 1 AND 2
C   PANEL CHARTS...USES BASIC TITLE INFO GENERATED BY PREVIOUS CALL TO
C   DOFRST...DESIGNED FOR INTERNATIONAL AVIATION PACKAGE PROGRAMS
C   AVPOLAR AND AVMERC ONLY...MUST BE CALLED IN SLOT LOOP.
c  
C  3/15/96 added character*8 equivalences to integer variables 
c  to pass character arguments to putlab
C
      COMMON/TITLES/KTITLE(28),LPOLAR,LOWLEV
      character*8 ctitle(28)
      equivalence (ctitle,ktitle)
C
      INTEGER   K2TITL(16)
      character*8 C2TITL(16)
c      equivalence (c2titl,k2titl)
C
      CHARACTER*64  B2TITL
      CHARACTER*112  BTITLE
      CHARACTER*1 NEWDAT(12)
C
      INTEGER   IBLANK
      character*8 cblank
      equivalence (cblank,iblank)
      dimension kvv(2)
      DATA      IBLANK/4H    /
      INTEGER   K2XTRA(2)
      character*8 c2xtra(2)
      equivalence (c2xtra,k2xtra)
      DATA      K2XTRA    /4HFL  ,4H VT /
      INTEGER   NEWLIN(7)
      character*8 CEWLIN(7)
      equivalence (CEWLIN,newlin)
      character*28 cew28
      DATA      NEWLIN    /4HUNSI,4HGNED,4H TEM,4HPS A,
     #                     4HRE N,4HEGAT,4HIVE /
C
      integer*8 mapv,mask8,ivar    !modified by kumar
      LOGICAL   LPOLAR
      LOGICAL   LOWLEV
C
      DATA MAPV/X'5600000000000000'/,MASK8/X'FF00000000000000'/
c      DATA MAPV/X'E500000000000000'/,MASK8/X'FF00000000000000'/
c      DATA MAPV/X'E5000000'/,MASK8/X'FF000000'/
      DATA BIG/15.3846/,SMALL/10.0/
C
c      EQUIVALENCE(K2TITL(6),NEWDAT(1))
       equivalence(b2titl(37:37),newdat(1))
      EQUIVALENCE(K2TITL(10),NEWDAT(1))
      EQUIVALENCE(B2TITL,c2TITL(1)(1:1))
c      EQUIVALENCE(BTITLE,cTITLE(1)(5:5))
c      EQUIVALENCE(B2TITL,K2TITL(1))
      EQUIVALENCE(BTITLE,KTITLE(1))
C
      IVAR=IAND(ISLOTA,MASK8)
      print 9301,ivar,islota,mask8,mapv
 9301 format('LPUT ',4z20,' 1=iand(2,3)')
      WRITE(BTITLE(1:5),FMT='(A4,A1)')ISLOTA,ISLOTB
C   TEST IF VARIAN MAP...IF NOT, SKIP THIS SECTION.
      IF(IVAR.NE.MAPV)GOTO 300
Corig PRINT 200,(KTITLE(I),I=1,28)
      WRITE(6,200) (KTITLE(I),I=1,28)
  200 FORMAT('0VARIAN TITLE=',28A4)
      IXD=150
      IF(LPOLAR)IXD=700
      NCHAR=112
      IF(LOWLEV)NCHAR=76
      CALL lPUTLAB(IXD,20,11.0,BTITLE,0.0,NCHAR,0,0)
      IDUCK=1860
      IF(LPOLAR)IDUCK=2410
      print 1954,iduck,20
 1954 format(' CALLING DUCK FROM VARIAN ',2i9)
      CALL DUCK(IDUCK,20,0,10)
      RETURN
C
C   COMES HERE IF NOT A VARIAN MAP
C
  300 IF(IPANA.EQ.IBLANK) GOTO 400
Corig PRINT 350
      WRITE(6,350)
  350 FORMAT('0THIS IS AN INSET MAP---TITLE(S) ALREADY GENERATED')
      RETURN
  400 LABELS=1
      IF(IRLAB.GT.0)LABELS=2
      IF(INSET.GT.0)GOTO 1000
Corig PRINT 500,(KTITLE(I),I=1,28)
      WRITE(6,500) (KTITLE(I),I=1,28)
  500 FORMAT('01-PANEL STRIP TITLE=',26A4,/,21X,2A4)
      DO 900 I=1,LABELS
      JX2=JX2+INCR
      NCHAR=52
      IF(LOWLEV)NCHAR=16
cc      CALL lPUTLAB(700,20,11.0,BTITLE,0.0,112,0,0)
      print 1974
      print 1974,btitle(1:60),btitle(61:112)
c 3/15/96  George Vandenberghe.  Changed ktitle to ctitle in putlab callS
C      CALL PUTLAB(50,JX2,11.0,BTITLE(1:60),0.0,60,0,0)
      CALL lPUTLAB(50,JX2,11.0,BTITLE(1:60),0.0,60,0,0)
c     CALL lPUTLAB(50,JX2,11.0,CTITLE(1),0.0,60,0,0)
c      CALL PUTLAB(950,JX2,1.0,BTITLE(61:112),0.0,NCHAR,0,0)
      CALL lPUTLAB(950,JX2,1.0,BTITLE(61:112),0.0,NCHAR,0,0)
c      CALL lPUTLAB(950,JX2,1.0,CTITLE(16),0.0,NCHAR,0,0)
 1079  format(' AVTT PUTLAB  above duck ',a120)
      IXL=950+((NCHAR+1)*SMALL)
      print 1964,ixl,jx2
 1964 format(' CALLING DUCK FROM SINGLE  ',2i9)
      CALL DUCK(IXL,JX2,0,10)
Corig PRINT 850,JX2
      WRITE(6,850) JX2
  850 FORMAT(' 1-PANEL STRIP TITLE WRITTEN AT J=',I5)
  900 CONTINUE
      RETURN
C
C   COMES HERE IF 2-PANEL FAX MAP
C
 1000 DO 1100 I=1,5
c      K2TITL(I)=KTITLE(I)
 1100 CONTINUE
      b2titl(1:20)=btitle(1:20)
      WRITE(B2TITL(21:28),FMT='(8HG VALID )')
c      DO 1300 I=8,16
c      K2TITL(I)=KTITLE(I+3)
c 1300 CONTINUE
      b2titl(29:64)=btitle(41:76)
Corig PRINT 1350,(K2TITL(I),I=1,16),(K2TITL(I),I=1,16)
      WRITE(6,1350) (K2TITL(I),I=1,16),(K2TITL(I),I=1,16)
 1350 FORMAT('02-PANEL STRIP TITLE=',16A4,4X,9A4,/,21X,7A4)
      DO 1400 IJ=8,10
      NEWDAT(IJ)=NEWDAT(IJ+2)
 1400 CONTINUE
Corig PRINT 1410
      WRITE(6,1410)
 1410 FORMAT(2X,'***** NOTE:  2-PANEL STRIP TITLE HAS BEEN CHANGED',
     1       ' SO ''VALID'' IS NOW ''VT'' AND THE YEAR ''1985'' NOW',
     2       ' IS ''85''.',/,2X,'(CHANGED DECEMBER 4, 1985)')
C
C   WRITE THE 2-PANEL STRIP TITLE(S)
C
      DO 1500 I=1,LABELS
      print 1934,B2TITL,BTITLE(1:78)
      IXL=20
      JX2=JX2+INCR
      DO 1450 ISPAN=1,2
      print 1974,btitle(1:60),btitle(61:112)
 1974 format('kttl ',a60,a52)
ccc      CALL lPUTLAB(50,JX2,11.0,BTITLE(1:60),0.0,60,0,0)
      NCHAR=52
ccc      CALL lPUTLAB(950,JX2,1.0,BTITLE(61:112),0.0,NCHAR,0,0)
c  3/16/95 GWV  Replaced K2TITL with c2titl in call below
      IF(I.NE.1.OR.ISPAN.NE.2)
     #CALL lPUTLAB(IXL,JX2,1.0,C2TITL(1)(1:5),0.0,5,0,
     #0)
      iXL=IXL+5*SMALL
      CALL lPUTLAB(IXL,JX2,11.0,C2XTRA(1)(1:2),0.0,2,0,0)
      IXL=IXL+2*BIG
c      CALL lPUTLAB(IXL,JX2,11.0,C2TITL(3),0.0,13,0,0)
      CALL lPUTLAB(IXL,JX2,11.0,B2TITL(9:21),0.0,13,0,0)

      IXL=IXL+13*BIG
      CALL lPUTLAB(IXL,JX2,1.0,C2XTRA(2)(1:4),0.0,4,0,0)
      IXL=IXL+4*SMALL
      CALL lPUTLAB(IXL,JX2,11.0,B2TITL(29:45),0.0,17,0,0)
c      CALL lPUTLAB(IXL,JX2,11.0,C2TITL(8),0.0,17,0,0)
      IXL=IXL+17*BIG
      CALL lPUTLAB(IXL,JX2,1.0,CBLANK,0.0,1,0,0)
      IXL=IXL+1*SMALL
      IF(ISPAN .EQ. 1)GO TO 1430
        CALL lPUTLAB(IXL,JX2,1.0,B2TITL(49:64),0.0,16,0,0)
 1934  format(' B2TITL is ',a64,/,'BTITLE IS ',a78)
c        CALL lPUTLAB(IXL,JX2,1.0,C2TITL(13),0.0,16,0,0)
        
        GO TO 1450
 1099   format(' below panel strip title ',i9)
 1430 CONTINUE
      IF(I .EQ. 1)GO TO 1440
c        IF(.NOT.LOWLEV)CALL lPUTLAB(IXL,JX2,1.0,CEWLIN,0.0,28,0,0)
c  pack 4 characters of each of 7 CEWLIN words into
c  character string 
        write(cew28,1992)(CEWLIN(K),K=1,7) 
       print 1934,B2TITL,BTITLE(1:78)
 1992   format(7a4) 
        IF(.NOT.LOWLEV)CALL lPUTLAB(IXL,JX2,1.0,CEW28,0.0,28,0,0)
        IF(LOWLEV)CALL lPUTLAB(IXL,JX2,1.0,B2TITL(49:64),0.0,16,0,0)
c        IF(LOWLEV)CALL lPUTLAB(IXL,JX2,1.0,C2TITL(13),0.0,16,0,0)
        IXL=894
      GO TO 1450
 1440 CONTINUE
        IXL=IXL+3*SMALL
        print 1944,ixl,jx2
 1944   format(' CALLING DUCK from dbl  ',2i9)
        CALL DUCK(IXL,JX2,0,10)
        IXL=894
 1450 CONTINUE
Corig PRINT 1470,JX2
      WRITE(6,1470) JX2
 1470 FORMAT(' 2-PANEL STRIP TITLE WRITTEN AT J=',I5)
 1500 CONTINUE
      RETURN
      END
