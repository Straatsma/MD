      module prepare_data

      implicit none

      real (kind=8), parameter :: tiny=1.0d-12, small=1.0d-6
      real (kind=8), parameter :: fourth=2.5d-01, half=5.0d-01
      real (kind=8), parameter :: third=3.333333333333d-01
      real (kind=8), parameter :: zero=0.0d0,one=1.0d0,two=2.0d0
      real (kind=8), parameter :: three=3.0d0,four=4.0d0,six=6.0d0
      real (kind=8), parameter :: twelve=1.2d01
      real (kind=8), parameter :: version=0.1d0

      integer, parameter :: mcount=10, mfract=250, mion=7, madd=25

!     mdirpar : maximum number of parameter directories
!     mfilpar : maximum number of parameter files per parameter directory

      integer, parameter :: mdirpar=6, mfilpar=4, mslv=3

!     ndirpar     : number of parameter directories
!     nfilpar(i)  : number of parameter files in i-th directory

      integer :: ndirpar,nfilpar(mdirpar)

!     ffield      : name of the force field
!     dirpar(i)   : name of i-th parameter directory
!     filpar(i,j) : name of j-th parameter file in i-th directory

      character (len=80) :: ffield
      character (len=255) :: dirpar(mdirpar),filpar(mdirpar,mfilpar)
      character (len=255) :: filmst,filinp,filout

      character (len=255) :: filpdb,filseq,filtop,filrst,filep,filtmp
      character (len=255) :: filcmd,filmod,prefix,filxyz,filqqq,filnoe
      character (len=255) :: filpmf,filpov,filhop,filbsg,filfrg,filsgm
      character (len=255) :: filmrg(100),filslv
      character (len=255) :: item,sysnam,calc
      character (len=80) :: title(2,3)
      character (len=10) :: date,time,dattop,timtop,datrst,timrst
      character (len=10) :: slvmdl(mslv)
      character (len=32) :: user
      character (len=3) :: slvnam(mslv),namslv
      character (len=80) :: source
      character (len=1) :: altloc,chain,his
      character (len=4) :: scount(mcount)
      character (len=255) :: dirs(9)
      character (len=10) :: cadd(madd)

!     logical file numbers

      integer :: lfnpdb,lfninp,lfnout,lfnfrg,lfnseq,lfnsgm,lfntop,lfnrst
      integer :: lfnpar,lfnxyz,lfnqqq,lfnnoe,lfnpmf,lfnpov,lfnmat,lfnmrg
      integer :: lfnmst,lfnslv,lfnmod,lfnhdb,lfnhop,lfnbsg,lfntmp,lfncmd

!     input variables

      integer :: ntitle,newtop,newseq,newrst,mgrid,mnoe,mpmf,maxscf
      integer :: ncount,nfract,icyren,iconst,model,nxlnk,ignore,nxrep
      integer :: nyrep,nzrep,irrep,nrepeat,nrgrid,itopol,icomb,iogrid(5)
      integer :: ifract(mfract),icount(mcount),numslv
      integer :: ipardef,link
      real (kind=8) :: rgrid,qscale,rrep,rdist,scale,cpk,fcount,touch
      real (kind=8) ::xpnd(3),box(3),rogrid(2,5),wcorr(1)
      real (kind=8) :: q14fac,releps,boxs(3)

!     logicals

      logical :: lsqu,ltop,lrst,lpdb,lfrg,ltouch,lrdcoo,lwrcoo,needwt
      logical :: lslvnt,lws,lpbc,lbox

!     numbers

      integer :: natm,nseq,nssb,nlnk,nlnkf,nsgm,nzmat,nparms,nparmsp
      integer :: nato,nbnd,nang,ndih,nimp,nfrb,npar,nsato,nsbnd,nsang
      integer :: nsdih,nsimp,nsgl,nsnon,natt,nslv,nmol,nunon,nsa,nwm
      integer :: nwa,nwx,nws,nsm,nadd,nsadd,ladd(madd),ngrid,ngx,ngy,ngz

!     dimensions

      integer :: matm,mseq,mssb,mlnk,msgm,mzmat,mparms,mato,mbnd,mang
      integer :: mdih,mimp,mfrb,mpar,msato,msbnd,msang,msdih,msimp
      integer :: msgl,msnon,matt,mmol,msa,mwm,mwa,mwx,mws

!     optional parameters

      real (kind=8) :: rsgm,dgrid,dgx,dgy,dgz,dx0,dy0,dz0
      integer :: islv,npbtyp,nbxtyp,lrgpdb

!     arrays

      integer, allocatable :: lseq(:,:), lsgm(:,:), llnk(:,:)
      integer, allocatable :: lsnon(:,:), latm(:,:), lato(:,:)
      integer, allocatable :: lssb(:,:), lfrb(:,:)
      integer, allocatable :: lbnd(:,:), lang(:,:), ldih(:,:), limp(:,:)
      integer, allocatable :: izmat(:,:), latt(:,:), lsgl(:,:)
      integer, allocatable :: lsndx(:,:,:), lsato(:,:), lsbnd(:,:)
      integer, allocatable :: lsang(:,:), lsdih(:,:), lsimp(:,:)
      integer, allocatable :: ls(:,:), lw(:,:), lwx(:,:)
      character (len=255), allocatable :: fils(:)
      character (len=6), allocatable :: cato(:,:), catm(:,:), catt(:,:)
      character (len=5), allocatable :: cseq(:,:), csgm(:,:), csato(:,:)
      character (len=5), allocatable :: cs(:,:), cw(:,:)
      character (len=4), allocatable :: clnk(:,:), csgl(:,:)
      real (kind=8), allocatable :: ratt(:), patt(:,:,:,:)
      real (kind=8), allocatable :: xato(:,:), qato(:)
      real (kind=8), allocatable :: xatm(:,:), qatm(:,:,:)
      real (kind=8), allocatable :: zmat(:,:)
      real (kind=8), allocatable :: sato(:,:,:), sbnd(:,:,:)
      real (kind=8), allocatable :: sang(:,:,:), sdih(:,:,:,:)
      real (kind=8), allocatable :: simp(:,:,:)
      real (kind=8), allocatable :: qs(:), xs(:,:), vs(:,:)
      real (kind=8), allocatable :: xw(:,:,:), vw(:,:,:)
      real (kind=8), allocatable :: xws(:,:,:), vws(:,:,:)
      real (kind=8), allocatable :: xwx(:,:,:), vwx(:,:,:)
      real (kind=8), allocatable :: pgrid(:,:,:)
      logical, allocatable :: lgrid(:,:,:)

      end module prepare_data


      program prepare

      use prepare_data

      implicit none

      call prepare_init()
      call prepare_main()
      call prepare_finish()

      end

      subroutine prepare_main()

      use prepare_data

      implicit none

#include "inp.fh"

      integer ::  numcmd

      call suser(user)

      numcmd=0

      if(.not.inp_read()) stop 'Error in read'

    1 continue
      if(.not.inp_a(item)) then
    2 continue
      if(.not.inp_read()) then
      item='end'
      return
      else
      if(.not.inp_a(item)) goto 2
      endif
      endif
    3 continue

!     define the system

      if(inp_compare(.false.,'system',item)) then
      if(.not.inp_a(sysnam)) stop 'pre_input: error sysnam'
      call prepare_system()
      endif

!     generate a sequence

      if(inp_compare(.false.,'sequence',item)) then
    4 continue
      if(inp_a(item)) then
      if(.not.(inp_compare(.false.,'topology',item).or.
     & inp_compare(.false.,'restart',item).or.
     & inp_compare(.false.,'end',item))) then
      filseq=item
      goto 4
      endif
      endif
      call prepare_sequence()
      endif

!     generate a topology

      if(inp_compare(.false.,'topology',item)) then
    5 continue
      if(inp_a(item)) then
      if(.not.(inp_compare(.false.,'restart',item).or.
     & inp_compare(.false.,'end',item))) then
      filtop=item
      goto 5
      endif
      endif
      call prepare_topology()
      endif

!     generate a restart

      if(inp_compare(.false.,'restart',item)) then
    6 continue
      if(inp_a(item)) then
      if(.not.inp_compare(.false.,'end',item)) then
      filrst=item
      goto 6
      endif
      endif

      write(lfnout,333) item
  333 format('DIRECTIVE RESTART ',a)
      call prepare_restart()
      endif

      if(inp_compare(.false.,'system',item)) goto 3
      if(.not.inp_compare(.false.,'end',item)) then
      write(lfnout,999) item
  999 format('Unrecognized directive ',a)
      endif

      return
      end

      subroutine prepare_init()

      use prepare_data

      implicit none

#include "util.fh"

      integer :: i
      character (len=255) :: key,value

!     set logical file numbers

      lfninp=5
      lfnout=6
      lfnpdb=12
      lfnfrg=13
      lfnseq=14
      lfnsgm=15
      lfntop=16
      lfnrst=17
      lfnpar=18
      lfntmp=19
      lfncmd=20
      lfnslv=21
      lfnmod=22
      lfnxyz=23
      lfnqqq=24
      lfnnoe=25
      lfnpmf=26
      lfnpov=27
      lfnmat=28
      lfnmrg=29
      lfnhdb=30
      lfnhop=31
      lfnmst=32
      lfnbsg=33

!     set defaults

      lsqu=.false.
      ltop=.false.
      lrst=.false.
      lpdb=.false.

      title(1,1)='ARGOS topology file'
      title(1,2)=' '
      title(1,3)='Generated by the ARGOS prepare module'
      title(2,1)='ARGOS restart file'
      title(2,2)=' '
      title(2,3)='Generated by the ARGOS prepare module'
      ntitle=-1

      ffield=' '
      do i=1,9
       dirs(i)=' '
      enddo

      nslv=-1
      sysnam=' '
      slvnam(1)='HOH'
      slvmdl(1)='spce      '
      altloc='A'
      chain='*'
      his=' '
      newtop=0
      newseq=0
      newrst=0
      source='pdb'
      mgrid=24
      rgrid=0.4d0
      mnoe=0
      mpmf=0
      maxscf=0
      qscale=-1.0d0
      ncount=0
      nfract=0
      icyren=0
      iconst=0
      model=0
      nxlnk=0
      ignore=0
      nxrep=0
      nyrep=0
      nzrep=0
      irrep=0
      rrep=0.25d0
      rdist=0.0d0
      scale=-1.0d0
      cpk=-1.0d0
      nrepeat=0
      fcount=1.0d0
      nrgrid=0
      itopol=0
      icomb=0

      touch=0.25d0
      xpnd(1)=0.00d0
      xpnd(2)=0.00d0
      xpnd(3)=0.00d0
      box(1)=0.0d0
      box(2)=0.0d0
      box(3)=0.0d0

      ltouch=.false.
      lrdcoo=.false.
      lwrcoo=.false.
      lslvnt=.false.
      needwt=.false.

      call get_input_filename(key)

      filinp=key(1:index(key,' ')-1)//'.inp'
      filout=filinp(1:index(filinp,'.'))//'out'

      open(unit=lfninp,file=filinp(1:index(filinp,' ')-1))
      open(unit=lfnout,file=filout(1:index(filout,' ')-1))

      write(lfnout,1000)
 1000 format(' ARGOS PREPARE MODULE',//,
     & ' ARGOS was written by T.P.Straatsma',/)

!     get defaults from $HOME/.argosrc

      key='ffield '
      if(util_argosrc_get(key,value)) then
      ffield=value(1:index(value,' ')-1)
      call prepare_paths() 
      endif

      key='histidine'
      if(his.eq.' ') then
      if(util_argosrc_get(key,value)) then
      if(value(1:3).eq.'HID') his='D'
      if(value(1:3).eq.'HIE') his='E'
      if(value(1:3).eq.'HIP') his='P'
      else
      his='E'
      endif
      endif

      namslv='HOH'
      key='solvent_name'
      if(util_argosrc_get(key,value)) then
      namslv=value(1:index(value,' ')-1)
      endif

      if(.not.util_argosrc_get(slvmdl(1),filslv))
     & stop 'no solvent file on .argosrc'
      lws=.false.

      return
      end

      subroutine prepare_finish()

      use prepare_data

      implicit none

      close(unit=lfninp,status='keep')
      close(unit=lfnout,status='keep')

      return
      end

      subroutine prepare_paths()

      use prepare_data

      implicit none

#include "util.fh"

      integer :: i,j,len,lend,ifc
      character (len=255) :: key,value

      ndirpar=9
      do i=1,mdirpar
       nfilpar(i)=0
       write(key,'(a,a,i1,a)') ffield(1:index(ffield,' ')-1),'_',i,' '
       if(util_argosrc_get(key,value)) then
        len=index(value,' ')-1
        if(len.gt.0) then
         lend=len
         if(len.gt.4) then 
          if(value(len-3:len).eq.'.par') then
           do j=1,len
            if(value(j:j).eq.'/') lend=j
           enddo
           endif
          endif
          dirpar(i)=value(1:lend)
          if(value(lend:lend).ne.'/') dirpar(i)(lend+1:lend+1)='/'
          if(len.eq.lend) then
           nfilpar(i)=1
           filpar(i,1)=ffield(1:index(ffield,' ')-1)//'.par '
          else
           nfilpar(i)=0
           ifc=lend+1
           do j=lend+1,len
            if(value(j:j).eq.',') then
             nfilpar(i)=nfilpar(i)+1
             filpar(i,nfilpar(i))=value(ifc:j-1)//' '
             ifc=j+1
           elseif(j.eq.len) then
            nfilpar(i)=nfilpar(i)+1
            filpar(i,nfilpar(i))=value(ifc:len)//' '
           endif
          enddo
         endif
        endif
       endif
      enddo

      if(nfilpar(mdirpar).eq.0) then
       nfilpar(mdirpar)=1
       dirpar(mdirpar)='./'
       filpar(mdirpar,1)=ffield(1:index(ffield,' ')-1)//'.par'
      endif

      do i=1,mdirpar
       if(nfilpar(i).gt.0) then
        do j=1,nfilpar(i)
         write(lfnout,'(a,a)') dirpar(i)(1:index(dirpar(i),' ')-1),
     &    filpar(i,j)(1:index(filpar(i,j),' ')-1)
        enddo
       endif
      enddo

      return
      end

      subroutine prepare_system()

      use prepare_data

      implicit none

#include "inp.fh"

      integer :: ndx,len,lenc
      logical :: ltitle
      integer :: ititle
      character (len=255) :: card

    1 continue
      if(.not.inp_a(item)) then
    2  continue
       if(.not.inp_read()) then
        item='end'
        return
       else
        if(.not.inp_a(item)) goto 2
       endif
      endif

!     title

      if(inp_compare(.false.,'title',item)) then
   11  continue
       ntitle=0
       ltitle=inp_a(item)
       ititle=0
       if(ltitle) then
       if(inp_compare(.false.,'topology',item)) then
       ititle=1
       elseif(inp_compare(.false.,'restart',item)) then
       ititle=2
       endif
       endif
       if(ititle.eq.0.or.ititle.eq.1) then
       title(1,1)=' '
       title(1,2)=' '
       title(1,3)=' '
       endif
       if(ititle.eq.0.or.ititle.eq.2) then
       title(2,1)=' '
       title(2,2)=' '
       title(2,3)=' '
       endif
   12  continue
       if(.not.inp_read()) stop 'inp_read failed'
       if(.not.inp_line(card)) stop 'inp_line'
       if(.not.inp_a(item)) stop 'inp_read failed'
       if(inp_compare(.false.,'title',item)) goto 11
       if(inp_compare(.false.,'end_title',item)) then
       write(lfnout,13)
   13  format('Title')
       goto 1
      endif
      ntitle=ntitle+1
      if(ntitle.gt.3) stop 'pre_input: too many title lines'
      if(ititle.eq.0) then
      title(1,ntitle)=card
      title(2,ntitle)=card
      endif
      if(ititle.eq.1) title(1,ntitle)=card
      if(ititle.eq.2) title(2,ntitle)=card
      goto 12
      endif

!     source

      if(inp_compare(.false.,'source',item)) then
       if(.not.inp_a(source)) stop 'pre_input: error source'
       filpdb=source
       goto 1
      endif

!     force field

   21 continue
      if(inp_compare(.false.,'amber',item)) then
      ffield='amber '
      if(icomb.eq.0) icomb=3
      goto 1
      endif
      if(inp_compare(.false.,'charmm',item)) then
      ffield='charmm '
      if(icomb.eq.0) icomb=3
      goto 1
      endif
      if(inp_compare(.false.,'gromos',item)) then
      ffield='gromos '
      goto 1
      endif
      if(inp_compare(.false.,'oplsa',item)) then
      ffield='oplsa '
      goto 1
      endif
      if(inp_compare(.false.,'oplsg',item)) then
      ffield='oplsg '
      goto 1
      endif
      if(inp_compare(.false.,'ffield',item)) then
      if(.not.inp_a(item)) stop 'error ffield'
      goto 21
      endif

      if(ntitle.lt.0) then
      title(1,1)=
     & 'ARGOS topology file for '//sysnam(1:index(sysnam,' ')-1)
      title(2,1)=
     & 'ARGOS restart file for '//sysnam(1:index(sysnam,' ')-1)
      endif

      ndx=index(sysnam,'_')
      len=index(sysnam,' ')
      if(ndx.gt.1.and.ndx.lt.len-1) then
      calc=sysnam(ndx+1:len)
      sysnam=sysnam(1:ndx-1)//' '
      else
      calc='md '
      endif

      len=index(sysnam,' ')-1
      lenc=index(calc,' ')-1

      filpdb=sysnam(1:len)//'.pdb '
      filpov=sysnam(1:len)//'.pov '
      if(source.ne.'pdb'.and.source(1:1).ne.' ') filpdb=source
      filxyz=sysnam(1:len)//'.xyz '
      filqqq=sysnam(1:len)//'.q '
      filnoe=sysnam(1:len)//'.drs '
      filpmf=sysnam(1:len)//'.pmf '
      filtop=sysnam(1:len)//'.top '
      filseq=sysnam(1:len)//'.seq '
      filmod=sysnam(1:len)//'.mod '
      filcmd=sysnam(1:len)//'.cmd '
      filhop=sysnam(1:len)//'.hop '
      filbsg=sysnam(1:len)//'.bsg '
      filtmp=sysnam(1:len)//'.nam '
      filrst=sysnam(1:len)//'_'//calc(1:lenc)//'.rst '

      open(unit=lfnmod,file=filmod(1:index(filmod,' ')-1),
     & form='formatted',status='unknown',err=99)
      open(unit=lfncmd,file=filcmd(1:index(filcmd,' ')-1),
     & form='formatted',status='unknown',err=99)

      return

   99 stop 'Error in opening file'

      return
      end

      subroutine prepare_sequence()

      use prepare_data

      implicit none

#include "inp.fh"

      write(lfnout,1000)
 1000 format(' ARGOS PREPARE SEQUENCE',/)

      if(source(1:3).ne.'pdb') stop 'Source format error'

      nadd=0
      nsadd=0

    1 continue
      if(.not.inp_a(item)) then
    2 continue
      if(.not.inp_read()) then
      item='end'
      else
      if(.not.inp_a(item)) goto 2
      endif
      endif

      if(inp_compare(.false.,'add',item)) then
      nadd=nadd+1
      if(nadd.gt.madd) stop 'Increase dimension madd'
      if(.not.inp_i(ladd(nadd))) stop 'Error in add'
      nsadd=nsadd+ladd(nadd)
      goto 1
      endif

      call prepare_pdb_dimensions()
      call prepare_pdb_allocate()
      call prepare_pdb_sequence()

!     sequence modifications

    3 continue

      if(inp_compare(.false.,'modify',item)) then

      if(.not.inp_a(item)) then
      if(.not.inp_read()) then
      item='end'
      else
      if(.not.inp_a(item)) stop 'Error in sequence modify'
      endif
      endif
      goto 3
      endif

      call prepare_pdb_segments()
      call prepare_pdb_deallocate()

      lsqu=.true.

      write(lfnout,444) item
  444 format('LEAVING SEQ ',a)

      return
      end

      subroutine prepare_pdb_dimensions()

      use prepare_data

      implicit none

      character (len=80) :: card
      integer :: length,mdl,isgm,i,ioff

      integer :: nchain,len
      character (len=1) :: pchain

      nslv=iabs(nslv)
      natm=0
      nseq=0
      nssb=0
      nchain=0
      mdl=0
      isgm=0
      nsgm=0
      nlnk=0
      ioff=0
      lslvnt=.false.
      numslv=0
      pchain=' '
      lrgpdb=0

!     open the pdb file

      len=index(filpdb,' ')-1
      open(lfnpdb,file=filpdb(1:len),form='formatted',
     & status='old',err=99)

    1 continue

      read(lfnpdb,100,end=999,err=9999) card
  100 format(a)

!     lrgpdb option

      if(card(1:6).eq.'LRGPDB') then
      lrgpdb=1
      goto 1
      endif

!     MODEL

      if(model.ne.mdl) then
      if(card(1:6).eq.'MODEL ') then
      read(card(7:14),102) mdl
  102 format(i8)
      if(model.eq.mdl) then
      write(lfnout,2005) model
 2005 format(10x,'MODEL ',i8)
      endif
      goto 1
      endif
      endif

!     END and ENDMDL

      if(card(1:6).eq.'ENDMDL') then
      if(model.eq.mdl) goto 9
      goto 1
      endif
      if(card(1:6).eq.'END   ') goto 9

!     HEADER

      if(card(1:6).eq.'HEADER') then
      write(lfnout,2001) card
 2001 format(10x,a)
      goto 1
      endif

!     FORMUL

      if(card(1:6).eq.'FORMUL'.and.card(19:19).eq.'*') then
      namslv=card(13:15)
      endif

!     SEQRES

      if(card(1:6).eq.'SEQRES') then
      read(card(14:17),1001) nseq
 1001 format(i4)
      goto 1
      endif

!     SSBOND

      if(card(1:6).eq.'SSBOND') then
      nssb=nssb+1
      goto 1
      endif

!     LINK

      if(card(1:6).eq.'LINK  ') then
      nlnk=nlnk+1
      goto 1
      endif

!     ATOM

      if(card(1:4).eq.'ATOM') then
      if(card(17:17).ne.' '.and.
     & card(17:17).ne.altloc.and.altloc.ne.'*') goto 1
      if(card(22:22).ne.' '.and.
     & card(22:22).ne.chain.and.chain.ne.'*') goto 1
      if(mdl.eq.model) then
      if(card(18:20).eq.namslv) lslvnt=.true.
      if(.not.lslvnt) natm=natm+1
      if(lrgpdb.eq.0) then
      read(card(23:26),1003) i
 1003 format(i4)
      else
      read(card(21:26),1023) i
 1023 format(i6)
      endif
      if(i.ne.isgm.or.card(22:22).ne.pchain) then
      if(i+ioff.lt.isgm) ioff=isgm+1-i
      isgm=i+ioff
      if(lslvnt) then
      numslv=numslv+1
      else
      nseq=nseq+1
      nchain=nchain+1
      endif
      endif
      pchain=card(22:22)
      endif
      goto 1
      endif

!     HETATM

      if(card(1:6).eq.'HETATM') then
      if(card(17:17).ne.' '.and.
     & card(17:17).ne.altloc.and.altloc.ne.'*') goto 1
      if(card(22:22).ne.' '.and.
     & card(22:22).ne.chain.and.chain.ne.'*') goto 1
      if(mdl.eq.model) then
      if(card(18:20).eq.namslv) lslvnt=.true.
      if(.not.lslvnt) natm=natm+1
      read(card(23:26),1004) i
 1004 format(i4)
      if(i.ne.isgm.or.card(22:22).ne.pchain) then
      isgm=i
      if(lslvnt) then
      numslv=numslv+1
      else
      nseq=nseq+1
      nchain=nchain+1
      endif
      endif
      pchain=card(22:22)
      endif
      goto 1
      endif

!     TER

      if(card(1:6).eq.'TER   ') then
      nchain=0
      endif

      goto 1

    9 continue

      close(lfnpdb)

!     print the dimensions read form the source file

      write(lfnout,1005) filpdb(1:len),natm,nsgm,nssb,nlnk,numslv
 1005 format(' PDB file',t40,a,/,
     & ' Number of atoms',t40,i10,/,
     & ' Number of segments',t40,i10,/,
     & ' Number of SS-bonds',t40,i10,/,
     & ' Number of links',t40,i10,/,
     & ' Number of solvent molecules',t40,i10,/)

      return

   99 stop 'Error opening pdb file'
  999 stop 'Unexpected EOF on pdb file'
 9999 stop 'Error reading pdb file'

      return
      end

      subroutine prepare_pdb_allocate()

      use prepare_data

      implicit none

!     set dimensions

      matm=natm
      mseq=nseq+2+nsadd
      mssb=nssb
      mlnk=nlnk+5*nseq

!     allocate memory for atom list

!     integer latm(1,matm) : index in sequence list
!                  2       : atomic number (0=undeterminable)
!                  3       : number of bonds to this atom
!                  4       : atom center type
!                  5       : link number

      allocate(latm(5,matm))

!     char*6  catm(1,matm) : atom name on pdb
!                  2       : atom name on top
!                  3       : atom type

      allocate(catm(3,matm))

!     real*8  xatm(1:3,matm) : atomic coordinates in nm

      allocate(xatm(3,matm))

!     real*8 qatm(matm) : partial atomic charges

!     allocate memory for secondary segment links

!     integer lssb(1,mssb) : link segment 1
!                  2       : link segment 2

      allocate(lssb(2,mssb))

!     integer llnk(1,mlnk) : link segment 1
!                  2       : link segment 2 atom number
!                  3       : link segment 1 global atom number
!                  4       : link segment 2 global atom number
!     char*4  clnk(1,mlnk) : link segment 1 atom name
!                  2       : link segment 2 atom name

      allocate(llnk(4,mlnk))
      allocate(clnk(2,mlnk))

!     allocate memory for sequence

!     integer lseq(1,mseq) : number of sequence entry
!                  2       : index into unique segment list
!                  3       : index of first atom of sequence entry
!                  4       : molecule number

      allocate(lseq(6,mseq))

!     char*5  cseq(1,mseq) : name of sequence entry on pdb
!                  2       : name of sequence entry on top

      allocate(cseq(2,mseq))

      return
      end

      subroutine prepare_pdb_deallocate()

      use prepare_data

      implicit none

!     deallocate memory

      deallocate(csgm)
      deallocate(lsgm)
      deallocate(cseq)
      deallocate(lseq)
      deallocate(clnk)
      deallocate(llnk)
      deallocate(lssb)
      deallocate(xatm)
      deallocate(catm)
      deallocate(latm)

      return
      end

      subroutine prepare_pdb_sequence()

      use prepare_data

      implicit none

      character*80 card
      integer len,mdl,iseq,isgm,i,j,k,nchain,iatm,ioff,mol,nlnkp
      integer nshort,nlnko,link1,link2,link3,m,l,ishort(10),jshort(10)
      integer iu,num1,num2,ion(mion)
      real*8 rshort(10)
      character*1 pchain,dorr
      character*2 elemnt,ctest
      character*5 string
      logical flag1,lwarn

      integer atom_number,prepare_short_list
      external atom_number,prepare_short_list

      logical amino_acid,nucleic_acid
      external amino_acid,nucleic_acid

      mdl=0
      iseq=0
      isgm=0
      nchain=0
      iatm=0
      nssb=0
      nlnk=0
      ioff=0
      pchain=' '
      ion(1)=3
      ion(2)=11
      ion(3)=12
      ion(4)=17
      ion(5)=19
      ion(6)=20
      ion(7)=35

!     initialize the lists

!     lseq(1,i) : actual residue number on pdb file

      do i=1,mseq
       cseq(1,i)='     '
       cseq(2,i)='     '
       lseq(1,i)=0
       lseq(2,i)=0
       lseq(3,i)=0
       lseq(4,i)=0
       lseq(5,i)=0
       lseq(6,i)=0
      enddo

      do i=1,matm
       latm(1,i)=0
       latm(2,i)=0
       latm(3,i)=0
       latm(4,i)=0
       latm(5,i)=0
       catm(1,i)='      '
       catm(2,i)='      '
       catm(3,i)='      '
      enddo

!     open the pdb file

      len=index(filpdb,' ')-1
      write(lfnout,555) filpdb(1:len)
  555 format('PDB FILE ',a)
      open(lfnpdb,file=filpdb(1:len),form='formatted',
     & status='old',err=99)
      rewind(lfnpdb)
      write(lfnout,556) filpdb(1:len)
  556 format('PDB FILE ',a,' open')

    1 continue

      read(lfnpdb,100,end=999,err=9999) card
  100 format(a)

!     MODEL

      if(model.ne.mdl) then
      if(card(1:6).eq.'MODEL ') then
      read(card(7:14),102) mdl
  102 format(i8)
      goto 1
      endif
      endif

!     END and ENDMDL

      if(card(1:6).eq.'ENDMDL') then
      if(model.eq.mdl) goto 9
      goto 1
      endif
      if(card(1:6).eq.'END   ') goto 9

!     HEADER

      if(card(1:6).eq.'HEADER') goto 1

!     SSBOND

      if(card(1:6).eq.'SSBOND') then
      nssb=nssb+1
      if(nssb.gt.mssb) stop 'increase mssb'
      read(card,2007) lssb(1,nssb),lssb(2,nssb)
 2007 format(17x,i4,10x,i4)
      goto 1
      endif

!     LINK

      if(card(1:6).eq.'LINK  ') then
      if(nlnk.gt.mlnk) stop 'increase mlnk'
      if(card(22:22).ne.' '.and.
     & card(22:22).ne.chain.and.chain.ne.'*') goto 1
      if(card(52:52).ne.' '.and.
     & card(52:52).ne.chain.and.chain.ne.'*') goto 1
      nlnk=nlnk+1
      read(card,2011)
     & clnk(1,nlnk),llnk(1,nlnk),clnk(2,nlnk),llnk(2,nlnk)
 2011 format(12x,a4,6x,i4,16x,a4,6x,i4)
      llnk(3,nlnk)=0
      llnk(4,nlnk)=0
      goto 1
      endif

!     ATOM

      if(card(1:4).eq.'ATOM') then
      if(card(17:17).ne.' '.and.
     & card(17:17).ne.altloc.and.altloc.ne.'*') goto 1
      if(card(22:22).ne.' '.and.
     & card(22:22).ne.chain.and.chain.ne.'*') goto 1
      if(mdl.eq.model) then
      read(card(23:26),1003) i
 1003 format(i4)
      if(chain.eq.'*') then
      if(i.lt.isgm) then
      if(card(22:22).ne.pchain) ioff=(isgm/100+1)*100-i
      i=i+ioff
      endif
      endif
      pchain=card(22:22)
      if(card(18:20).eq.namslv) goto 9
      if(i.ne.isgm) then
      isgm=i
      iseq=iseq+1
      nchain=nchain+1
      if(iseq.ge.mseq) stop 'Insufficient memory'
      lseq(1,iseq)=isgm
      cseq(1,iseq)(1:3)=card(18:20)
      lseq(3,iseq)=0
      endif
      iatm=iatm+1
      if(lseq(3,iseq).eq.0) lseq(3,iseq)=iatm
      lseq(3,iseq+1)=iatm+1
      latm(1,iatm)=iseq
      latm(2,iatm)=atom_number(card(77:78))
      if(latm(2,iatm).eq.0) latm(2,iatm)=atom_number(card(13:14))
      catm(1,iatm)(1:4)=card(13:16)
      read(card(31:54),'(3f8.3)') (xatm(j,iatm),j=1,3)
      endif
      goto 1
      endif

!     HETATM

      if(card(1:6).eq.'HETATM') then
      if(card(17:17).ne.' '.and.
     & card(17:17).ne.altloc.and.altloc.ne.'*') goto 1
      if(card(22:22).ne.' '.and.
     & card(22:22).ne.chain.and.chain.ne.'*') goto 1
      if(mdl.eq.model) then
      read(card(23:26),1004) i
 1004 format(i4)
      if(chain.eq.'*') then
      if(i.lt.isgm) then
      if(card(22:22).ne.pchain) ioff=(isgm/100+1)*100-i
      i=i+ioff
      endif
      endif
      pchain=card(22:22)
      if(card(18:20).eq.namslv) goto 9
      if(i.ne.isgm) then
      isgm=i
      iseq=iseq+1
      nchain=nchain+1
      if(iseq.ge.mseq) stop 'Insufficient memory'
      lseq(1,iseq)=isgm
      cseq(1,iseq)(1:3)=card(18:20)
      lseq(3,iseq)=0
      endif
      iatm=iatm+1
      if(lseq(3,iseq).eq.0) lseq(3,iseq)=iatm
      lseq(3,iseq+1)=iatm+1
      latm(1,iatm)=iseq
      latm(2,iatm)=atom_number(card(77:78))
      if(latm(2,iatm).eq.0) latm(2,iatm)=atom_number(card(13:14))
      catm(1,iatm)(1:4)=card(13:16)
      read(card(31:54),'(3f8.3)') (xatm(j,iatm),j=1,3)
      endif
      goto 1
      endif

!     TER

!      if(card(1:6).eq.'TER   ') then
!      if(iseq.gt.0) then
!      if(nchain.eq.1) then
!      cseq(1,iseq)(4:5)='_M'
!      else
!      cseq(1,iseq)(4:5)='_C'
!      endif
!      endif
!      nchain=0
!      endif

      goto 1

    9 continue

      close(lfnpdb)
      write(lfnout,557) filpdb(1:len)
  557 format('PDB FILE ',a,' closed')

      if(iseq.ne.nseq) then
      write(lfnout,2008) iseq,nseq
 2008 format(10x,i8,' segments read from PDB while expecting ',i8)
      stop
      endif

!     add additional segments to the sequence

      do i=1,nadd
       do j=1,ladd(i)
        iseq=iseq+1
        if(iseq.gt.mseq) stop 'Increase dimension mseq'
        lseq(1,iseq)=iseq
       enddo
      enddo

      nseq=iseq

!     take white space out of segment names

      k=0
      do i=1,iseq
       write(lfnout,4008) i,cseq(1,i)
 4008  format('Segment ',i6,1x,a)
       k=0
       do j=1,5
        if(cseq(1,i)(j:j).ne.' ') then
         k=k+1
         cseq(1,i)(k:k)=cseq(1,i)(j:j)
        endif
       enddo
       k=k+1
       do j=k,5
        cseq(1,i)(j:j)=' '
       enddo
      enddo

!     since mseq>nseq lseq(3,nseq+1) can hold natm+1

      lseq(3,nseq+2)=natm+1

!     convert from Angstrom to nm

      do i=1,natm
       xatm(1,i)=1.0d-01*xatm(1,i)
       xatm(2,i)=1.0d-01*xatm(2,i)
       xatm(3,i)=1.0d-01*xatm(3,i)
      enddo

!     comply with IUPAC atom naming

      flag1=.false.
      do i=1,natm
       if(amino_acid(ffield,cseq(1,latm(1,i)))) then
        if(catm(1,i)(1:2).eq.'1H') flag1=.true.
       endif
       catm(2,i)=catm(1,i)
      enddo

!     IUPAC hydrogen naming

      if(flag1) then
       do i=1,natm
        if(amino_acid(ffield,cseq(1,latm(1,i)))) then
         if(catm(2,i)(1:2).eq.'3H') catm(2,i)(1:2)='4H'
         if(catm(2,i)(1:2).eq.'2H') catm(2,i)(1:2)='3H'
         if(catm(2,i)(1:2).eq.'1H') catm(2,i)(1:2)='2H'
        endif
       enddo
      endif

!     ILE CD1 -> CD

      do i=1,natm
       if(cseq(1,latm(1,i))(1:3).eq.'ILE') then
        if(catm(2,i)(1:4).eq.' CD1') then
         catm(2,i)(1:4)=' CD '
        endif
        if(catm(2,i)(2:4).eq.'HD1') then
         catm(2,i)(2:4)='HD '
        endif
       endif
      enddo

      do i=1,natm
       if(latm(2,i).le.0) latm(2,i)=atom_number(catm(2,i)(1:2))
       if(latm(2,i).eq.0) then
        elemnt(1:1)=' '
        elemnt(2:2)=catm(2,i)(2:2)     
        latm(2,i)=atom_number(elemnt)
       endif
      enddo

!     Read the explicit links from input

      rewind(unit=lfnmod)
   13 continue
      read(lfnmod,3000,end=14) card
 3000 format(a)
      if(card(1:4).eq.'link') then
      nlnk=nlnk+1
      if(nlnk.gt.mlnk) stop 'Increase dimension mlnk'
      read(card(6:80),3001)
     & llnk(1,nlnk),clnk(1,nlnk),llnk(2,nlnk),clnk(2,nlnk)
 3001 format(i5,a4,i5,a4)
      endif
      goto 13
   14 continue

!     get atom index for links input from pdb

      if(nlnk.gt.0) then
      do 21 i=1,nlnk
      do 22 j=1,nseq
      if(llnk(1,i).eq.lseq(1,j)) then
      llnk(1,i)=j
      goto 121
      endif
   22 continue
      stop 'Illegal link'
  121 continue
      do 212 j=1,nseq
      if(llnk(2,i).eq.lseq(1,j)) then
      llnk(2,i)=j
      goto 21
      endif
  212 continue
      stop 'Illegal link'
   21 continue
      do 23 i=1,nlnk
      do 24 j=lseq(3,llnk(1,i)),lseq(3,llnk(1,i)+1)-1
      if(clnk(1,i).eq.catm(2,j)(1:4)) llnk(3,i)=j
   24 continue
      do 25 j=lseq(3,llnk(2,i)),lseq(3,llnk(2,i)+1)-1
      if(clnk(2,i).eq.catm(2,j)(1:4)) llnk(4,i)=j
   25 continue
   23 continue
      endif
      nlnkf=0
      nlnkp=nlnk
      mol=0

!     check main chain links

      do 26 i=1,nseq-1
      mol=mol+1
      if(i.eq.1) lseq(4,i)=mol
      lseq(4,i+1)=mol+1
      nshort=prepare_short_list(xatm,latm,matm,
     & lseq(3,i),lseq(3,i+1)-1,lseq(3,i+1),lseq(3,i+2)-1,
     & ishort,jshort,rshort)
      if(nshort.gt.0) then
      do 27 j=1,nshort
      lseq(4,i+1)=lseq(4,i)
      if(latm(5,ishort(j)).eq.0.or.latm(5,ishort(j)).gt.1) then
      latm(5,ishort(j))=2
      else
      stop 'inconsistent links'
      endif
      if(latm(5,jshort(j)).eq.0.or.latm(5,jshort(j)).gt.1) then
      latm(5,jshort(j))=1
      else
      stop 'inconsistent links'
      endif
      if(.not.amino_acid(ffield,cseq(1,i)).or.
     & .not.amino_acid(ffield,cseq(1,i+1))) then
      nlnk=nlnk+1
      if(nlnk.gt.mlnk) stop 'increase mlnk'
      llnk(1,nlnk)=i
      llnk(2,nlnk)=i+1
      llnk(3,nlnk)=ishort(j)
      llnk(4,nlnk)=jshort(j)
      clnk(1,nlnk)=catm(2,ishort(j))(1:4)
      clnk(2,nlnk)=catm(2,jshort(j))(1:4)
      endif
   27 continue
      endif
   26 continue

!     check side chain links

      do 28 i=1,nseq-2
      do 29 j=i+2,nseq
      nshort=prepare_short_list(xatm,latm,matm,
     & lseq(3,i),lseq(3,i+1)-1,lseq(3,j),lseq(3,j+1)-1,
     & ishort,jshort,rshort)
      if(nshort.gt.0) then
      do 30 k=1,nshort
      num1=atom_number(catm(2,ishort(k))(1:2))
      num2=atom_number(catm(2,jshort(k))(1:2))
      do 301 m=1,mion
      if(num1.eq.ion(m).or.num2.eq.ion(m)) goto 30
  301 continue
      if(latm(5,ishort(k)).ne.0) goto 30
      if(latm(5,jshort(k)).ne.0) goto 30
      if(latm(5,ishort(k)).eq.0) latm(5,ishort(k))=3
      if(latm(5,jshort(k)).eq.0) latm(5,jshort(k))=3
      nlnk=nlnk+1
      if(nlnk.gt.mlnk) stop 'increase mlnk'
      llnk(1,nlnk)=i
      llnk(2,nlnk)=j
      llnk(3,nlnk)=ishort(k)
      llnk(4,nlnk)=jshort(k)
      clnk(1,nlnk)=catm(2,ishort(k))(1:4)
      clnk(2,nlnk)=catm(2,jshort(k))(1:4)
      write(lfnout,333) llnk(1,nlnk),llnk(2,nlnk),llnk(3,nlnk),
     & llnk(4,nlnk),clnk(1,nlnk),clnk(2,nlnk),num1,num2
  333 format(4i5,2a4,2i5)
      l=lseq(4,j)
      do 31 m=1,nseq
      if(lseq(4,m).eq.l) lseq(4,m)=lseq(4,i)
   31 continue
   30 continue
      endif
   29 continue
   28 continue

!     remove duplicate links

      if(nlnk.gt.0) then
      nlnko=nlnk
      nlnk=1
      if(nlnkp.ge.1) nlnkf=1
      do 32 i=2,nlnko
      do 33 j=1,nlnk
      if(llnk(1,i).eq.llnk(1,j).and.llnk(2,i).eq.llnk(2,j).and.
     & llnk(3,i).eq.llnk(3,j).and.llnk(4,i).eq.llnk(4,j).and.
     & clnk(1,i).eq.clnk(1,j).and.clnk(2,i).eq.clnk(2,j)) goto 32
      if(llnk(1,i).eq.llnk(2,j).and.llnk(2,i).eq.llnk(1,j).and.
     & llnk(3,i).eq.llnk(4,j).and.llnk(4,i).eq.llnk(3,j).and.
     & clnk(1,i).eq.clnk(2,j).and.clnk(2,i).eq.clnk(1,j)) goto 32
   33 continue
      nlnk=nlnk+1
      llnk(1,nlnk)=llnk(1,i)
      llnk(2,nlnk)=llnk(2,i)
      llnk(3,nlnk)=llnk(3,i)
      llnk(4,nlnk)=llnk(4,i)
      clnk(1,nlnk)=clnk(1,i)
      clnk(2,nlnk)=clnk(2,i)
      if(i.le.nlnkp) nlnkf=nlnk
   32 continue
      do 34 i=1,nlnk
      if(llnk(1,i).ne.llnk(2,i)) then
      if(latm(5,llnk(3,i)).eq.0) latm(5,llnk(3,i))=1
      if(latm(5,llnk(4,i)).eq.0) latm(5,llnk(4,i))=2
      endif
   34 continue
      endif

      do 35 i=1,nseq
      link1=0
      link2=0
      do 36 k=lseq(3,i),lseq(3,i+1)-1
      if(latm(5,k).eq.1) link1=k
      if(latm(5,k).eq.2) link2=k
   36 continue
      do 37 j=1,nseq
      if(cseq(1,i).eq.cseq(1,j)) then
      do 38 l=lseq(3,j),lseq(3,j+1)-1
      if(latm(5,l).ge.3) then
      if(catm(1,l).eq.catm(1,link1)) latm(5,l)=1
      if(catm(1,l).eq.catm(1,link2)) latm(5,l)=2
      endif
   38 continue
      endif
   37 continue
   35 continue 

!     change amino acid segment names based on links

      do 40 i=1,nseq 
      if(amino_acid(ffield,cseq(1,i))) goto 41
      if(nucleic_acid(ffield,cseq(1,i))) goto 42
      do 43 j=lseq(3,i),lseq(3,i+1)-1
      if(latm(5,j).eq.1) latm(5,j)=3
      if(latm(5,j).eq.2) latm(5,j)=3
   43 continue
      goto 40
   41 continue
      link1=0
      link2=0
      link3=0 
      do 44 j=lseq(3,i),lseq(3,i+1)-1
      if(latm(5,j).eq.1) link1=link1+1
      if(latm(5,j).eq.2) link2=link2+1
      if(latm(5,j).ge.3) link3=link3+1
   44 continue 
      iu=index(cseq(1,i),'_')
      if(iu.eq.0) iu=index(cseq(1,i),' ')
      if(link1.gt.0) then
      if(link2.eq.0) then
      cseq(1,i)(iu:iu+1)='_C'
      endif
      else
      if(link2.gt.0) then
      cseq(1,i)(iu:iu+1)='_N'
      else
      cseq(1,i)(iu:iu+1)='_M'
      endif
      endif
      goto 40
   42 continue
      link1=0
      link2=0
      link3=0
      do 45 j=lseq(3,i),lseq(3,i+1)-1
      if(latm(5,j).eq.1) link1=link1+1
      if(latm(5,j).eq.2) link2=link2+1
      if(latm(5,j).ge.3) link3=link3+1
   45 continue
      iu=index(cseq(1,i),'_')
      if(iu.eq.0) iu=index(cseq(1,i),' ')
      if(link1.gt.0) then
      if(link2.eq.0) then
      cseq(1,i)(iu:iu+1)='_3'
      endif
      else
      if(link2.gt.0) then
      cseq(1,i)(iu:iu+1)='_5'
      else
      cseq(1,i)(iu:iu+1)='_M'
      endif
      endif
   40 continue

!     adjust molecule number based on explicit links

      lwarn=.false.
      do 46 i=1,nlnk
      if(lseq(4,llnk(1,i)).ne.lseq(4,llnk(2,i))) then
      if(.not.lwarn) then
      write(lfnout,4000)
 4000 format(/,' Warning',//,
     & ' Explicit links were found that merge two molecules.',/,
     & ' This is usually indicative of a problem with the coordinates',
     & /,' or an incorrectly edited sequence file.',//)
      lwarn=.true.
      endif
      write(lfnout,4001) i,llnk(1,i),llnk(2,i),
     & lseq(4,llnk(1,i)),lseq(4,llnk(2,i))
 4001 format(' Molecule-molecule link ',5i7)
      j=lseq(4,llnk(2,i))
      do 47 k=1,nseq
      if(lseq(4,k).eq.j) then
      lseq(4,k)=lseq(4,llnk(1,i))
      elseif(lseq(4,k).gt.j) then
      lseq(4,k)=lseq(4,k)-1
      endif
   47 continue
      endif
   46 continue

!     adjust the segment names based on the force field definitions

      dorr='D'

      do 51 i=1,nseq
      cseq(2,i)=cseq(1,i)
      if(cseq(1,i)(1:3).eq.'U  ') dorr='R'
      if(cseq(1,i)(1:2).eq.'U_') dorr='R'
   51 continue

      if(ffield(1:5).eq.'amber') then
      do 52 i=1,natm

      if(cseq(2,latm(1,i))(1:3).eq.'HIS'.and.catm(2,i).eq.' HD1  ') then
      cseq(2,latm(1,i))(1:3)='HID'
      write(lfnout,1014) cseq(2,latm(1,i)),lseq(1,latm(1,i))
 1014 format(' Renamed ',a,i3.3,' (HD1 found)')
      endif
      if(cseq(2,latm(1,i))(1:3).eq.'HIS'.and.catm(2,i).eq.' HE2  ') then
      cseq(2,latm(1,i))(1:3)='HIE'
      write(lfnout,1005) cseq(2,latm(1,i)),lseq(1,latm(1,i))
 1005 format(' Renamed ',a,i3.3,' (HE2 found)')
      endif
      if(cseq(2,latm(1,i))(1:3).eq.'HID'.and.catm(2,i).eq.' HE2  ') then
      cseq(2,latm(1,i))(1:3)='HIP'
      write(lfnout,1006) cseq(2,latm(1,i)),lseq(1,latm(1,i))
 1006 format(' Renamed ',a,i3.3,' (HE2 found)')
      endif
      if(cseq(2,latm(1,i))(1:3).eq.'HIE'.and.catm(2,i).eq.' HD1  ') then
      cseq(2,latm(1,i))(1:3)='HIP'
      write(lfnout,1007) cseq(2,latm(1,i)),lseq(1,latm(1,i))
 1007 format(' Renamed ',a,i3.3,' (HD1 found)')
      endif
      if(icyren.eq.0) then
      if(cseq(2,latm(1,i))(1:3).eq.'CYS'.and.catm(2,i).eq.' SG   '.and.
     & latm(5,i).eq.3) then
      cseq(2,latm(1,i))(1:3)='CYX'
      write(lfnout,1008) cseq(2,latm(1,i)),lseq(1,latm(1,i))
 1008 format(' Renamed ',a,i3.3,' (SG found with link id 3)')
      endif
      else
      if(cseq(2,latm(1,i))(1:3).eq.'CYS'.and.catm(2,i).eq.' SG   ') then
      if(latm(5,i).ge.3) then
      if((cseq(2,llnk(1,latm(5,i)-2))(1:3).eq.'CYS'.or.
     & cseq(2,llnk(1,latm(5,i)-2))(1:3).eq.'CYX').and.
     & (cseq(2,llnk(1,latm(5,i)-2))(1:3).eq.'CYS'.or.
     & cseq(2,llnk(1,latm(5,i)-2))(1:3).eq.'CYX').and.
     & catm(2,llnk(3,latm(5,i)-2)).eq.' SG   '.and.
     & catm(2,llnk(4,latm(5,i)-2)).eq.' SG   ') then
      cseq(2,latm(1,i))(1:3)='CYX'
      write(lfnout,1009) cseq(2,latm(1,i)),lseq(1,latm(1,i))
 1009 format(' Renamed ',a,i3.3,' (SG-SG found with link id 3)')
      endif
      endif
      endif
      endif

      ctest=cseq(2,latm(1,i))(1:2)

      if(ctest.eq.'A '.or.ctest.eq.'A_'.or.
     & ctest.eq.'C '.or.ctest.eq.'C_'.or.
     & ctest.eq.'G '.or.ctest.eq.'G_')
     & cseq(2,latm(1,i))='D'//cseq(2,latm(1,i))(1:4)
      if(ctest.eq.'T '.or.ctest.eq.'T_')
     & cseq(2,latm(1,i))='D'//cseq(2,latm(1,i))(1:4)
      if(ctest.eq.'U '.or.ctest.eq.'U_')
     & cseq(2,latm(1,i))='R'//cseq(2,latm(1,i))(1:4)

      if(catm(2,i).eq.' O2*  '.and.
     & (cseq(2,latm(1,i))(1:3).eq.'DA '.or.
     &  cseq(2,latm(1,i))(1:3).eq.'DA_'.or.
     &  cseq(2,latm(1,i))(1:3).eq.'DC '.or.
     &  cseq(2,latm(1,i))(1:3).eq.'DC_'.or.
     &  cseq(2,latm(1,i))(1:3).eq.'DG '.or.
     &  cseq(2,latm(1,i))(1:3).eq.'DG_'))
     & cseq(2,latm(1,i))(1:1)='R'

   52 continue
      do 53 i=1,nseq
      if(cseq(2,i)(1:3).eq.'HIS'.and.his.eq.'D') cseq(2,i)(1:3)='HID'
      if(cseq(2,i)(1:3).eq.'HIS'.and.his.eq.'E') cseq(2,i)(1:3)='HIE'
      if(cseq(2,i)(1:3).eq.'HIS'.and.his.eq.'P') cseq(2,i)(1:3)='HIP'
   53 continue
      endif

      if(ffield(1:5).eq.'charm') then
      do 54 i=1,natm
      if(cseq(2,latm(1,i))(1:3).eq.'HIS'.and.catm(2,i).eq.' HD1  ')
     & cseq(2,latm(1,i))(1:3)='HSD'
      if(cseq(2,latm(1,i))(1:3).eq.'HIS'.and.catm(2,i).eq.' HE2  ')
     & cseq(2,latm(1,i))(1:3)='HSE'
      if(cseq(2,latm(1,i))(1:3).eq.'HSD'.and.catm(2,i).eq.' HE2  ')
     & cseq(2,latm(1,i))(1:3)='HSP'
      if(cseq(2,latm(1,i))(1:3).eq.'HSE'.and.catm(2,i).eq.' HD1  ')
     & cseq(2,latm(1,i))(1:3)='HSP'
      if(icyren.eq.0) then
      if(cseq(2,latm(1,i))(1:3).eq.'CYS'.and.catm(2,i).eq.' SG   '.and.
     & latm(5,i).eq.3) cseq(2,latm(1,i))(1:3)='CYX'
      else
      if(cseq(2,latm(1,i))(1:3).eq.'CYS'.and.catm(2,i).eq.' SG   ') then
      if(latm(5,i).ge.3) then
      if((cseq(2,llnk(1,latm(5,i)-2))(1:3).eq.'CYS'.or.
     & cseq(2,llnk(1,latm(5,i)-2))(1:3).eq.'CYX').and.
     & (cseq(2,llnk(1,latm(5,i)-2))(1:3).eq.'CYS'.or.
     & cseq(2,llnk(1,latm(5,i)-2))(1:3).eq.'CYX').and.
     & catm(2,llnk(3,latm(5,i)-2)).eq.' SG   '.and.
     & catm(2,llnk(4,latm(5,i)-2)).eq.' SG   ') then
      cseq(2,latm(1,i))(1:3)='CYX'
      endif
      endif
      endif
      endif
   54 continue
      endif

!     get modifications

      rewind(unit=lfnmod)
   55 continue
      read(lfnmod,5000,end=56) card
 5000 format(a)

      if(card(1:8).eq.'sequence') then
      card=card(9:80)
      i=index(card,':')
      if(i.le.1) stop 'modify sequence error'
      read(card(1:i-1),*) j
      do 57 k=1,nseq
      if(lseq(1,k).eq.j) then
      string=cseq(2,k)
      if(index(cseq(2,k),'_').eq.4) then
      cseq(2,k)=card(i+1:i+3)//cseq(2,k)(4:5)
      else
      cseq(2,k)=card(i+1:i+5)
      endif
      endif
   57 continue
      endif

   56 continue
      close(unit=lfnmod)

!      if(util_print('connectivity',print_debug)) then

      if(natm.gt.0) write(lfnout,6001)
 6001 format(/,
     & '    Atom Sgmnt Sgmnt Sgmnt   Atom   Atom Link   ',
     & '    Atom Sgmnt Sgmnt Sgmnt   Atom   Atom Link',/,
     & '  number number name  name   name   name        ',
     & '  number number name  name   name   name     ',/,
     & '                 PDB   top    PDB    top        ',
     & '                 PDB   top    PDB    top     ',/)
      k=natm/2
      if(natm.gt.2*k) k=k+1
      do 58 i=1,k
      l=i+k
      if(l.le.natm) then
      write(lfnout,6002) i,lseq(1,latm(1,i)),(cseq(j,latm(1,i)),j=1,2),
     & (catm(j,i),j=1,2),latm(5,i),
     & l,lseq(1,latm(1,l)),(cseq(j,latm(1,l)),j=1,2),
     & (catm(j,l),j=1,2),latm(5,l)
      else
      write(lfnout,6002) i,lseq(1,latm(1,i)),(cseq(j,latm(1,i)),j=1,2),
     & (catm(j,i),j=1,2),latm(5,i)
      endif
 6002 format(2(i8,i6,2(1x,a5),2(1x,a6),i5,3x))
   58 continue

!      determine the number of unique segments

      write(lfnout,6003)
 6003 format(/,' Unique segments  ',/)
      nsgm=0
      do 61 i=1,nseq
      do 62 j=1,i-1
      if(cseq(2,i).eq.cseq(2,j)) then
      lseq(2,i)=lseq(2,j)
      goto 61
      endif
   62 continue
      nsgm=nsgm+1
      lseq(2,i)=nsgm
      write(lfnout,6004) lseq(2,i),cseq(2,i)
 6004 format(i5,2x,a)
   61 continue

      msgm=nsgm+nslv

!     allocate memory for the segments

!     integer lsgm(1,msgm) : number of segments of this type
!                  2       : source, 0,1,2,3,4=?,s,x,u,t
!                  3       : number of atoms in segment

      allocate(lsgm(3,msgm))

!     char*5  csgm(msgm)   : segment names

      allocate(csgm(2,msgm))

      return

   99 stop 'Error opening pdb file'
  999 stop 'Unexpected EOF on pdb file'
 9999 stop 'Error reading pdb file'

      return
      end

      subroutine prepare_pdb_segments()

      use prepare_data

      implicit none

      character (len=255) :: filnam,dirnam,dirnm2,card

      integer i,j,l,ll,len,lend1,lend2,mol,molec,icon(16)

      lfrg=.false.

!     initialize  number of segments to zero
!                 source of segments to unknown

      do 1 i=1,nsgm
      lsgm(1,i)=0
      lsgm(2,i)=0
      lsgm(3,i)=0
    1 continue

!     find all unique segments in sequence csgm(1:nsgm) = segment names
!                                          lsgm(1,1:nsgm)

      mato=0
      do 2 i=1,nseq
      mato=max(mato,lseq(3,i+1)-lseq(3,i))
      csgm(1,lseq(2,i))=cseq(2,i)
      lsgm(1,lseq(2,i))=lsgm(1,lseq(2,i))+1
      if(lsgm(1,lseq(2,i)).eq.1) then
      csgm(1,lseq(2,i))=cseq(2,i)
      lsgm(3,lseq(2,i))=lseq(3,i+1)-lseq(3,i)
      endif
    2 continue

!     find segment files for the segments in the list

      do 3 i=1,nsgm
      len=index(csgm(1,i),' ')-1
      if(len.le.0) len=5
      lsgm(2,i)=0

!     check the temporary dbase directory

      do 4 j=mdirpar,1,-1
      if(nfilpar(j).gt.0) then
      filnam=
     & dirpar(j)(1:index(dirpar(j),' ')-1)//csgm(1,i)(1:len)//'.sgm '
      open(lfnsgm,file=filnam(1:index(filnam,' ')-1),form='formatted',
     & status='old',err=5)
      lsgm(2,i)=j
      close(lfnsgm)
      goto 6
    5 continue
      filnam=
     & dirpar(j)(1:index(dirpar(j),' ')-1)//csgm(1,i)(1:len)//'.frg '
      open(lfnfrg,file=filnam(1:index(filnam,' ')-1),form='formatted',
     & status='old',err=4)
      lsgm(2,i)=-j
      close(lfnfrg)
      goto 6
      endif
    4 continue
    6 continue

      if(lsgm(2,i).eq.0) lfrg=.true.

!      if(util_print('sequence',print_high)) then

      if(lsgm(2,i).lt.0)
     & write(lfnout,1001) i,csgm(1,i),lsgm(1,i),lsgm(2,i),
     & dirpar(-lsgm(2,i))(1:index(dirpar(-lsgm(2,i)),' ')-1)//
     & csgm(1,i)(1:len)//'.frg '
      if(lsgm(2,i).gt.0)
     & write(lfnout,1001) i,csgm(1,i),lsgm(1,i),lsgm(2,i),
     & dirpar(lsgm(2,i))(1:index(dirpar(lsgm(2,i)),' ')-1)//
     & csgm(1,i)(1:len)//'.sgm '
 1001 format(i5,2x,a5,i5,2x,i5,1x,a) 
      if(lsgm(2,i).eq.0) write(lfnout,1002) i,csgm(1,i),lsgm(1,i),
     & lsgm(2,i)
 1002 format(i5,2x,a5,i5,2x,i5,1x,' no definition file found') 

!      endif

    3 continue

!     Allocate arrays to create frg files

      if(lfrg) then

!     set dimensions for bonds, angles, torsions and out-of-plane

      mato=max(4*mato,6)
      mbnd=2*max(matm,mato)
      mang=2*max(matm,mato)
      mdih=3*max(matm,mato)
      mimp=max(matm,mato)
      mfrb=2*mato

!     allocate memory for segment atom lists

      allocate(lato(5,mato))
      allocate(cato(3,mato))
      allocate(xato(3,mato))
      allocate(qato(mato))
      allocate(lfrb(2,mfrb))

!     allocate memory for the bonded lists

!     integer lbnd(1:2,mbnd) : bond indices

      allocate(lbnd(2,mbnd))

!     integer lang(1:3,mang) : angle indices

      allocate(lang(3,mang))

!     integer ldih(1:4,mdih) : torsion indices

      allocate(ldih(4,mdih))

!     integer limp(1:4,mimp) : improper torsion indices

      allocate(limp(4,mimp))

!     Make fragment file

      call prepare_make_fragment()

!     deallocate memory

      deallocate(limp)
      deallocate(ldih)
      deallocate(lang)
      deallocate(lbnd)
      deallocate(lfrb)
      deallocate(qato)
      deallocate(xato)
      deallocate(cato)
      deallocate(lato)

      endif

!     Make any missing sgm files from existing frg files

      do 10 i=1,nsgm
      if(lsgm(2,i).lt.0) then

      len=index(csgm(1,i),' ')-1
      if(len.le.0) len=5

      dirnam=dirpar(-lsgm(2,i))
      lend1=index(dirnam,' ')-1
      dirnm2=dirpar(mdirpar)
      lend2=index(dirnm2,' ')-1

      filfrg=dirnam(1:lend1)//csgm(1,i)(1:len)//'.frg '
      filsgm=dirnm2(1:lend2)//csgm(1,i)(1:len)//'.sgm '

      write(lfnout,2001) filfrg(1:index(filfrg,' ')-1),
     & filsgm(1:index(filsgm,' ')-1)
 2001 format(' Converting ',a,' into ',a)

      len=index(filsgm,' ')-1

      write(lfnout,2000) filsgm(1:len)
 2000 format(//,'SEGMENT FILE ',a)

      natm=0
      nbnd=0
      nzmat=0

      len=index(filfrg,' ')-1

      open(unit=lfnfrg,file=filfrg(1:len),form='formatted',
     & status='old',err=999)

   11 continue

      read(lfnfrg,3000,end=999,err=999) card
 3000 format(a)

      if(card(1:1).eq.'#'.or.card(1:1).eq.'$') goto 11

      read(card,3001) natm,nparms,ipardef,nzmat
 3001 format(4i5)

      do 12 j=1,nparms*(natm+1)
      read(lfnfrg,3000,end=999,err=999) card
   12 continue

   13 continue
      read(lfnfrg,3002,end=19,err=999) icon
 3002 format(16i5)

      if(icon(1).ne.0) then
      do 14 j=2,16
      if(icon(j).ne.0) nbnd=nbnd+1
   14 continue
      goto 13
      endif

      read(lfnfrg,3000,end=19,err=999) card
      if(card(1:8).eq.'z-matrix') then
   15 continue
      read(lfnfrg,3003) j
 3003 format(i5)
      if(j.gt.0) then
      nzmat=nzmat+1
      goto 15
      endif
      endif

   19 continue

      close(lfnfrg)

!     allocate memory for bonds, angles, torsions and impropers

      matm=natm
      mbnd=4*matm
      if(mbnd.lt.nbnd) mbnd=nbnd
      mang=6*matm
      mdih=12*matm
      mimp=matm
      nang=0
      ndih=0
      nimp=0
      mzmat=nzmat+1
      nparmsp=nparms+1

!     allocate memory for atom list

!     integer latm(1,matm) :
!                  2       :
!                  3       :
!                  4       :
!                  5       :

      allocate(latm(6,matm))

!    char*255 fil

      allocate(fils(nparms))

!     char*6  catm(1,matm) : atom name
!                  2       : atom type

      allocate(catm(nparmsp,matm))

!     real*8 qatm(1,matm) : partial atomic charges
!                 2       : polarizabilities

      allocate(qatm(nparms,2,matm))

!     integer lbnd(1:2,mbnd) : bond indices

      allocate(lbnd(2,mbnd))

!     integer lang(1:3,mang) : angle indices

      allocate(lang(3,mang))

!     integer ldih(1:4,mdih) : torsion indices

      allocate(ldih(4,mdih))

!     integer limp(1:4,mimp) : improper torsion indices

      allocate(limp(4,mimp))

      if(mzmat.gt.0) then
       allocate(izmat(mzmat,4))
       allocate(zmat(mzmat,3))
      endif

!     read atom list and bond list from fragment file

      call prepare_read_fragment()

!     deallocate memory

      if(mzmat.gt.0) then
       deallocate(zmat)
       deallocate(izmat)
      endif
      deallocate(limp)
      deallocate(ldih)
      deallocate(lang)
      deallocate(lbnd)
      deallocate(qatm)
      deallocate(catm)
      deallocate(fils)
      deallocate(latm)

      lsgm(2,i)=mdirpar
      endif
   10 continue

!     Now write the sequence file

      len=index(filseq,' ')-1

      open(unit=lfnseq,file=filseq(1:len),form='formatted',
     & status='unknown',err=9999)
      rewind(unit=lfnseq)

      write(lfnseq,4000) nseq,mseq,nsgm,msgm,nlnk,mlnk,nslv,mslv
 4000 format('seq ',2i8,/,'sgm ',2i8,/,'lnk ',2i8,/,'slv ',2i8)

      ll=0
      mol=0
      molec=1
      do 21 i=1,nseq
      if(i.gt.1.and.lseq(4,i).ne.mol) then
      if(nfract.eq.0) then
      write(lfnseq,4001)
 4001 format('molecule')
      else
      do 22 j=1,nfract
      if(ifract(j).eq.molec) then
      write(lfnseq,4001)
      goto 23
      endif
   22 continue
      write(lfnseq,4001)
   23 continue
      endif
      molec=molec+1
      endif
      mol=lseq(4,i)
      len=index(cseq(2,i),'_')-1
      if(len.le.0) len=5
      write(lfnseq,4002) lseq(1,i),cseq(2,i)
 4002 format(i5,a)
      ll=lseq(1,i)
   21 continue

      if(ncount.gt.0) then
      write(lfnseq,4003)
 4003 format('fraction')
      l=0
      do 24 i=1,ncount
      do 25 j=1,icount(i)
      l=l+1
      write(lfnseq,4004) ll+l,scount(i)
 4004 format(i5,a)
      if(i.lt.ncount.or.j.lt.icount(i)) write(lfnseq,4005)
 4005 format('molecule')
   25 continue

      write(lfnout,4006) icount(i),scount(i)
 4006 format(' Appended ',i5,' counter ions ',a,' to topology')

   24 continue
      endif

      do 27 i=1,nlnk
      if(i.le.nlnkf) then
      write(lfnseq,4007) lseq(1,llnk(1,i)),clnk(1,i),
     & lseq(1,llnk(2,i)),clnk(2,i)
 4007 format('LINK ',i5,a4,i5,a4)
      else
      write(lfnseq,4008) lseq(1,llnk(1,i)),clnk(1,i),
     & lseq(1,llnk(2,i)),clnk(2,i)
 4008 format('link ',i5,a4,i5,a4)
      endif
   27 continue

!     solvent model

      nslv=iabs(nslv)
      if(nslv.gt.0) then
      write(lfnseq,4009)
 4009 format('solvent')
      do 28 i=1,nslv
      write(lfnseq,4010) i,slvmdl(i)
 4010 format(i5,a)
   28 continue
      endif

      write(lfnseq,4011)
 4011 format('stop')

      close(unit=lfnseq)

      return

  999 stop 'Error reading frg file'
 9999 stop 'Error opening sgm file'
      return
      end

      subroutine prepare_read_fragment()

      use prepare_data

      implicit none

      integer atom_number
      external atom_number

      integer i,j,k,l,len,nd,no,icon(16),ltemp,na,ia(10),nia(10)
      character*255 card

      natm=0
      nbnd=0

      len=index(filfrg,' ')-1

      open(unit=lfnfrg,file=filfrg(1:len),form='formatted',
     & status='old',err=9999)

    1 continue

      read(lfnfrg,1000,end=9999,err=9999) card
 1000 format(a)

      if(card(1:1).eq.'#'.or.card(1:1).eq.'$') goto 1

      read(card,1001) natm
 1001 format(i5)

      do 101 i=1,nparms
      read(lfnfrg,1000) fils(i)
  101 continue

      do 2 i=1,natm
      read(lfnfrg,1002,end=9999,err=9999) catm(1,i),catm(2,i),
     & (latm(j,i),j=1,5),qatm(1,1,i),qatm(1,2,i)
 1002 format(5x,2a6,5i5,2f12.6)
      if(nparms.gt.1) then
      do 212 j=2,nparms
      read(lfnfrg,1003,end=9999,err=9999)
     & catm(j+1,i),qatm(j,1,i),qatm(j,2,i)
 1003 format(11x,a6,25x,2f12.6)
  212 continue
      endif
    2 continue

    3 continue
      read(lfnfrg,1000,end=9,err=9999) card
      read(card,1004,end=9,err=99) icon
 1004 format(16i5)

      if(icon(1).ne.0) then
      do 4 i=2,16
      if(icon(i).ne.0) then
      nbnd=nbnd+1
      lbnd(1,nbnd)=icon(i-1)
      lbnd(2,nbnd)=icon(i)
      endif
    4 continue
      goto 3
      endif

      nzmat=0
      read(lfnfrg,1000,end=9,err=9999) card
   99 continue
      if(card(1:8).eq.'z-matrix') then
   10 continue

      read(lfnfrg,1005) (izmat(nzmat+1,i),i=1,4),(zmat(nzmat+1,i),i=1,3)
 1005 format(4i5,3f12.6)
      if(izmat(nzmat+1,1).gt.0) then
      nzmat=nzmat+1
      goto 10
      endif
      endif

    9 continue

      close(lfnfrg)

      if(nbnd.gt.0) then
      do 5 i=1,nbnd
      if(lbnd(1,i).gt.lbnd(2,i)) then
      l=lbnd(1,i)
      lbnd(1,i)=lbnd(2,i)
      lbnd(2,i)=l
      endif
    5 continue
      l=nbnd
      nbnd=1
      do 6 i=2,l
      do 7 j=1,nbnd
      if(lbnd(1,i).eq.lbnd(1,j).and.lbnd(2,i).eq.lbnd(2,j)) goto 6
    7 continue
      nbnd=nbnd+1
    6 continue
      do 8 i=1,nbnd-1
      do 91 j=i+1,nbnd
      if(lbnd(1,i).gt.lbnd(1,j).or.
     & (lbnd(1,i).eq.lbnd(1,j).and.lbnd(2,i).gt.lbnd(2,j))) then
      l=lbnd(1,i)
      lbnd(1,i)=lbnd(1,j)
      lbnd(1,j)=l
      l=lbnd(2,i)
      lbnd(2,i)=lbnd(2,j)
      lbnd(2,j)=l
      endif
   91 continue
    8 continue
      endif

!     make the angle list

      do 11 i=1,nbnd-1
      do 12 j=i+1,nbnd
      if(lbnd(1,i).eq.lbnd(1,j)) then
      if(nang.ge.mang) return
      nang=nang+1
      lang(1,nang)=lbnd(2,i)
      lang(2,nang)=lbnd(1,i)
      lang(3,nang)=lbnd(2,j)
      else
      if(lbnd(2,i).eq.lbnd(1,j)) then
      if(nang.ge.mang) return
      nang=nang+1
      lang(1,nang)=lbnd(1,i)
      lang(2,nang)=lbnd(2,i)
      lang(3,nang)=lbnd(2,j)
      else
      if(lbnd(1,i).eq.lbnd(2,j)) then
      if(nang.ge.mang) return
      nang=nang+1
      lang(1,nang)=lbnd(2,i)
      lang(2,nang)=lbnd(1,i)
      lang(3,nang)=lbnd(1,j)
      else
      if(lbnd(2,i).eq.lbnd(2,j)) then
      if(nang.ge.mang) return
      nang=nang+1
      lang(1,nang)=lbnd(1,i)
      lang(2,nang)=lbnd(2,i)
      lang(3,nang)=lbnd(1,j)
      endif
      endif
      endif
      endif
   12 continue
   11 continue

      do 13 i=1,nang
      if(lang(1,i).gt.lang(3,i)) then
      ltemp=lang(1,i)
      lang(1,i)=lang(3,i)
      lang(3,i)=ltemp
      endif
   13 continue

      do 14 i=1,nang-1
      do 15 j=i+1,nang
      if(lang(2,i).gt.lang(2,j).or.
     & (lang(2,i).eq.lang(2,j).and.lang(1,i).gt.lang(1,j)).or.
     & (lang(2,i).eq.lang(2,j).and.lang(1,i).eq.lang(1,j).and.
     & lang(3,i).gt.lang(3,j))) then
      do 16 k=1,3
      ltemp=lang(k,i)
      lang(k,i)=lang(k,j)
      lang(k,j)=ltemp
   16 continue
      endif
   15 continue
   14 continue

!     make the dihedral list

      do 21 i=1,nang-1
      do 22 j=i+1,nang
      if(lang(2,i).eq.lang(1,j).and.lang(3,i).eq.lang(2,j)) then
      if(ndih.ge.mdih) return
      ndih=ndih+1
      ldih(1,ndih)=lang(1,i)
      ldih(2,ndih)=lang(2,i)
      ldih(3,ndih)=lang(3,i)
      ldih(4,ndih)=lang(3,j)
      else
      if(lang(2,i).eq.lang(3,j).and.lang(3,i).eq.lang(2,j)) then
      if(ndih.ge.mdih) return
      ndih=ndih+1
      ldih(1,ndih)=lang(1,i)
      ldih(2,ndih)=lang(2,i)
      ldih(3,ndih)=lang(3,i)
      ldih(4,ndih)=lang(1,j)
      else
      if(lang(1,i).eq.lang(2,j).and.lang(2,i).eq.lang(3,j)) then
      if(ndih.ge.mdih) return
      ndih=ndih+1
      ldih(1,ndih)=lang(1,j)
      ldih(2,ndih)=lang(1,i)
      ldih(3,ndih)=lang(2,i)
      ldih(4,ndih)=lang(3,i)
      else
      if(lang(1,i).eq.lang(2,j).and.lang(2,i).eq.lang(1,j)) then
      if(ndih.ge.mdih) return
      ndih=ndih+1
      ldih(1,ndih)=lang(3,j)
      ldih(2,ndih)=lang(1,i)
      ldih(3,ndih)=lang(2,i)
      ldih(4,ndih)=lang(3,i)
      endif
      endif
      endif
      endif
   22 continue
   21 continue

      do 23 i=1,ndih
      if(ldih(2,i).gt.ldih(3,i)) then
      ltemp=ldih(2,i)
      ldih(2,i)=ldih(3,i)
      ldih(3,i)=ltemp
      ltemp=ldih(1,i)
      ldih(1,i)=ldih(4,i)
      ldih(4,i)=ltemp
      endif
   23 continue

      do 24 i=1,ndih-1
      do 25 j=i+1,ndih
      if(ldih(2,i).gt.ldih(2,j).or.
     & (ldih(2,i).eq.ldih(2,j).and.ldih(3,i).gt.ldih(3,j)).or.
     & (ldih(2,i).eq.ldih(2,j).and.ldih(3,i).eq.ldih(3,j).and.
     &  ldih(1,i).gt.ldih(1,j)).or.
     & (ldih(2,i).eq.ldih(2,j).and.ldih(3,i).eq.ldih(3,j).and.
     &  ldih(1,i).eq.ldih(1,j).and.ldih(4,i).gt.ldih(4,j))) then
      do 26 k=1,4
      ltemp=ldih(k,i)
      ldih(k,i)=ldih(k,j)
      ldih(k,j)=ltemp
   26 continue
      endif
   25 continue
   24 continue

!     make the improper list

      nimp=0

!     loop over all atoms

      do 31 i=1,natm
      if(latm(2,i).gt.0) then

!     count the number of bonds to this atom

      na=0
      do 32 j=1,nbnd
      if(lbnd(1,j).eq.i) then
      na=na+1
      ia(na)=lbnd(2,j)
      endif
      if(lbnd(2,j).eq.i) then
      na=na+1
      ia(na)=lbnd(1,j)
      endif
   32 continue

      nia(1)=0
      nia(2)=0
      nia(3)=0
      do 33 k=1,nbnd
      if(lbnd(1,k).eq.ia(1)) nia(1)=nia(1)+1
      if(lbnd(2,k).eq.ia(1)) nia(1)=nia(1)+1
      if(lbnd(1,k).eq.ia(2)) nia(2)=nia(2)+1
      if(lbnd(2,k).eq.ia(2)) nia(2)=nia(2)+1
      if(lbnd(1,k).eq.ia(3)) nia(3)=nia(3)+1
      if(lbnd(2,k).eq.ia(3)) nia(3)=nia(3)+1
   33 continue
      do 34 k=1,2
      do 35 l=2,3
      if(nia(k).lt.nia(l)) then
      ltemp=nia(k)
      nia(k)=nia(l)
      nia(l)=ltemp
      ltemp=ia(k)
      ia(k)=ia(l)
      ia(l)=ltemp
      endif
   35 continue
   34 continue

!     planar

      if(latm(2,i).eq.1.and.na.eq.3) then
      nimp=nimp+1
      limp(1,nimp)=i
      limp(2,nimp)=ia(1)
      limp(3,nimp)=ia(2)
      limp(4,nimp)=ia(3)
      endif

!     chiral

      if((latm(2,i).eq.2.or.latm(2,i).eq.3).and.na.eq.3) then
      nimp=nimp+1
      limp(1,nimp)=i
      limp(2,nimp)=ia(1)
      limp(3,nimp)=ia(2)
      limp(4,nimp)=ia(3)
      endif

!     aromatic ring

      if(latm(2,i).ge.4.and.na.eq.3.and.
     & ((ffield(1:5).eq.'amber'.and.latm(2,i).le.6).or.
     & (ffield(1:5).eq.'charm'))) then
      nimp=nimp+1
      limp(1,nimp)=i
      limp(2,nimp)=ia(1)
      limp(3,nimp)=ia(2)
      limp(4,nimp)=ia(3)
      endif

      endif
   31 continue

!     select dihedrals

      if(ffield(1:6).eq.'gromos') then

      nd=ndih
      ndih=0
      do 41 i=1,nd
      do 42 j=1,ndih
      if(ldih(2,i).eq.ldih(2,j).and.ldih(3,i).eq.ldih(3,j)) then
      if(atom_number(catm(1,ldih(1,i)))+
     & atom_number(catm(1,ldih(4,i))).lt.
     & atom_number(catm(1,ldih(1,j)))+
     & atom_number(catm(1,ldih(4,j)))) then
      ldih(2,i)=ldih(2,j)
      ldih(4,i)=ldih(4,j)
      endif
      goto 41
      endif
   42 continue
      ndih=ndih+1
      ldih(1,ndih)=ldih(1,i)
      ldih(2,ndih)=ldih(2,i)
      ldih(3,ndih)=ldih(3,i)
      ldih(4,ndih)=ldih(4,i)
   41 continue
      endif

!     switch propers to impropers

      if(ffield(1:6).eq.'gromos'.or.ffield(1:6).eq.'charmm') then

      no=nimp

!     dihedrals in aromatic ring are treated as improper by gromos
!                                            both proper and improper by charmm

      do 51 i=1,ndih
      if(latm(2,ldih(1,i)).lt.4) goto 51
      if(latm(2,ldih(2,i)).lt.4) goto 51
      if(latm(2,ldih(3,i)).lt.4) goto 51
      if(latm(2,ldih(4,i)).lt.4) goto 51
      do 52 j=1,nang
      if(latm(2,lang(1,j)).lt.4) goto 52
      if(latm(2,lang(2,j)).lt.4) goto 52
      if(latm(2,lang(3,j)).lt.4) goto 52
      if((ldih(1,i).eq.lang(1,j).and.ldih(4,i).eq.lang(3,j)).or.
     & (ldih(1,i).eq.lang(3,j).and.ldih(4,i).eq.lang(2,j))) then
      do 53 k=no+1,nimp
      if(limp(1,k).eq.i) goto 52
   53 continue
      nimp=nimp+1
      limp(1,nimp)=i
      endif
   52 continue
   51 continue

      do 54 i=1,ndih-1
      if(latm(2,ldih(1,i)).lt.4) goto 54
      if(latm(2,ldih(2,i)).lt.4) goto 54
      if(latm(2,ldih(3,i)).lt.4) goto 54
      if(latm(2,ldih(4,i)).lt.4) goto 54
      do 55 j=i+1,ndih
      if(latm(2,ldih(1,j)).lt.4) goto 55
      if(latm(2,ldih(2,j)).lt.4) goto 55
      if(latm(2,ldih(3,j)).lt.4) goto 55
      if(latm(2,ldih(4,j)).lt.4) goto 55
      if((ldih(1,i).eq.ldih(1,j).and.ldih(4,i).eq.ldih(4,j)).or.
     & (ldih(1,i).eq.ldih(4,j).and.ldih(4,i).eq.ldih(4,j))) then
      do 56 k=no+1,nimp
      if(limp(1,k).eq.i) goto 57
   56 continue
      nimp=nimp+1
      limp(1,nimp)=i
   57 continue
      do 58 k=no+1,nimp
      if(limp(1,k).eq.j) goto 55
   58 continue
      nimp=nimp+1
      limp(1,nimp)=j
      endif
   55 continue
   54 continue

      do 59 i=no+1,nimp
      k=limp(1,i)
      do 60 j=1,4
      limp(j,i)=ldih(j,k)
   60 continue
      if(ffield(1:6).eq.'gromos') ldih(1,k)=0
   59 continue

      no=ndih
      ndih=0
      do 61 i=1,no
      if(ldih(1,i).gt.0) then
      ndih=ndih+1
      do 62 j=1,4
      ldih(j,ndih)=ldih(j,i)
   62 continue
      endif
   61 continue

      endif

!     write segment file

      len=index(filsgm,' ')-1
      open(unit=lfnsgm,file=filsgm(1:len),form='formatted',
     & status='new',err=9998)

      call swatch(date,time)

      write(lfnsgm,2000) date,time
 2000 format('# This is an automatically generated segment file',/,
     & '# ',2a10)

      write(lfnsgm,2001) 4.6
 2001 format(f12.6)

      write(lfnsgm,2002) natm,nbnd,nang,ndih,nimp,nzmat,nparms,ipardef
 2002 format(8i5)

      write(lfnsgm,2003) (0.0,j=1,nparms)
 2003 format(f12.6)

      do 71 i=1,natm
      write(lfnsgm,2004) i,catm(1,i),(latm(j,i),j=1,5)
 2004 format(i5,a6,5i5)
      do 72 j=1,nparms
      write(lfnsgm,2005) catm(1+j,i),qatm(j,1,i),qatm(j,2,i)
 2005 format(5x,a6,2f12.6)
   72 continue
   71 continue

      do 73 i=1,nbnd
      write(lfnsgm,2006) i,(lbnd(j,i),j=1,2),0,0
 2006 format(5i5)
      do 74 j=1,nparms
      write(lfnsgm,2007) 0.0d0,0.0d0
 2007 format(f12.6,e12.5)
   74 continue
   73 continue

      do 75 i=1,nang
      write(lfnsgm,2008) i,(lang(j,i),j=1,3),0,0
 2008 format(6i5)
      do 76 j=1,nparms
      write(lfnsgm,2009) 0.0d0,0.0d0
 2009 format(f10.6,e12.5)
   76 continue
   75 continue

      do 77 i=1,ndih
      write(lfnsgm,2010) i,(ldih(j,i),j=1,4),0,0
 2010 format(7i5)
      do 78 j=1,nparms
      write(lfnsgm,2011) 0,0.0d0,0.0d0
 2011 format(i3,f10.6,e12.5)
   78 continue
   77 continue

      do 79 i=1,nimp
      if(ffield(1:5).eq.'amber') then
      write(lfnsgm,2012) i,limp(2,i),limp(3,i),limp(1,i),limp(4,i),
     & 0,0
 2012 format(7i5)
      do 80 j=1,nparms
      write(lfnsgm,2013) 0,0.0d0,0.0d0
 2013 format(i3,f10.6,e12.5)
   80 continue
      else
      write(lfnsgm,2012) i,(limp(j,i),j=1,4),0,0
      do 81 j=1,nparms
      write(lfnsgm,2013) 0,0.0d0,0.0d0
   81 continue
      endif
   79 continue

      do 82 i=1,nzmat
      write(lfnsgm,2014) i,(izmat(i,j),j=1,4),(zmat(i,j),j=1,3)
 2014 format(5i5,3f12.6)
   82 continue

      close(unit=lfnsgm)

      return

 9999 stop 'Error reading frg'
 9998 stop 'Error writing sgm'
      return
      end

      subroutine prepare_make_fragment()

      use prepare_data

      implicit none

      real*8 qsum

      return
      end

      logical function amino_acid(ffield,sgmnam)

      implicit none

      character*80 ffield
      character*5 sgmnam

      amino_acid=.true.

      if(sgmnam(1:3).eq.'ALA'.or.sgmnam(1:3).eq.'ARG'.or.
     & sgmnam(1:3).eq.'ASN'.or.sgmnam(1:3).eq.'ASP'.or.
     & sgmnam(1:3).eq.'CYS'.or.sgmnam(1:3).eq.'GLN'.or.
     & sgmnam(1:3).eq.'GLU'.or.sgmnam(1:3).eq.'GLY'.or.
     & sgmnam(1:3).eq.'HIS'.or.sgmnam(1:3).eq.'ILE'.or.
     & sgmnam(1:3).eq.'LEU'.or.sgmnam(1:3).eq.'LYS'.or.
     & sgmnam(1:3).eq.'MET'.or.sgmnam(1:3).eq.'PHE'.or.
     & sgmnam(1:3).eq.'PRO'.or.sgmnam(1:3).eq.'SER'.or.
     & sgmnam(1:3).eq.'THR'.or.sgmnam(1:3).eq.'TRP'.or.
     & sgmnam(1:3).eq.'TYR'.or.sgmnam(1:3).eq.'VAL') return
      if(ffield(1:5).eq.'amber') then
      if(sgmnam(1:3).eq.'ASH'.or.sgmnam(1:3).eq.'CYX'.or.
     & sgmnam(1:3).eq.'GLH'.or.sgmnam(1:3).eq.'HID'.or.
     & sgmnam(1:3).eq.'HIE'.or.sgmnam(1:3).eq.'HIP') return
      endif
      if(ffield(1:6).eq.'charmm') then
      if(sgmnam(1:3).eq.'CYX'.or.sgmnam(1:3).eq.'HSD'.or.
     & sgmnam(1:3).eq.'HSE'.or.sgmnam(1:3).eq.'HSP') return
      endif

      amino_acid=.false.
      return
      end

      logical function nucleic_acid(ffield,sgmnam)

      implicit none

      character*80 ffield
      character*5 sgmnam

      nucleic_acid=.true.

      if(sgmnam(1:3).eq.'A  '.or.sgmnam(1:3).eq.'+A '.or.
     & sgmnam(1:3).eq.'C  '.or.sgmnam(1:3).eq.'+C '.or.
     & sgmnam(1:3).eq.'G  '.or.sgmnam(1:3).eq.'+G '.or.
     & sgmnam(1:3).eq.'I  '.or.sgmnam(1:3).eq.'+I '.or.
     & sgmnam(1:3).eq.'T  '.or.sgmnam(1:3).eq.'+T '.or.
     & sgmnam(1:3).eq.'U  '.or.sgmnam(1:3).eq.'+U ') return
      if(ffield(1:5).eq.'amber') then
      if(sgmnam(1:3).eq.'DA '.or.sgmnam(1:3).eq.'RA '.or.
     & sgmnam(1:3).eq.'DC '.or.sgmnam(1:3).eq.'RC '.or.
     & sgmnam(1:3).eq.'DG '.or.sgmnam(1:3).eq.'RG '.or.
     & sgmnam(1:3).eq.'DT '.or.sgmnam(1:3).eq.'RU ') return
      endif
      if(ffield(1:6).eq.'charmm') then
      endif

      nucleic_acid=.false.
      return
      end

      integer function prepare_short_list(xatm,latm,matm,
     & ilo,ihi,jlo,jhi,ishort,jshort,rshort)

!     function to find list of
!              atom ishort in [ilo:ihi] and jshort in [jlo,jhi]
!              with the shortest distance rshort in nm 

!     in  : xatm(3,matm) = atomic coordinates
!         : latm(2,matm) = atomic numbers
!         : matm         = dimension of coordinate list
!         : ilo          = atom index ilo
!         : ihi          = atom index ihi
!         : jlo          = atom index jlo
!         : jhi          = atom index jhi

!     out : ishort       = atom index i with shortest distance
!         : jshort       = atom index j with shortest distance
!         : rshort       = distance between atoms ishort and jshort

      implicit none

      real*8 atom_radius
      external atom_radius

      integer matm
      real*8 xatm(3,matm)
      integer latm(5,matm)
      integer ilo,ihi,jlo,jhi,ishort(10),jshort(10)
      real*8 rshort(10)

      integer i,j,k,l,number,ishrt,jshrt
      real*8 dist,short
      integer nsh,ish(100),jsh(100)
      real*8 rsh(100)
      logical new

      nsh=0
      do 1 i=ilo,ihi
      if(latm(2,i).gt.1) then
      do 2 j=jlo,jhi
      if(latm(2,j).gt.1) then
      dist=sqrt((xatm(1,i)-xatm(1,j))*(xatm(1,i)-xatm(1,j))+
     & (xatm(2,i)-xatm(2,j))*(xatm(2,i)-xatm(2,j))+
     & (xatm(3,i)-xatm(3,j))*(xatm(3,i)-xatm(3,j)))

      if(dist.lt.atom_radius(latm(2,i))+atom_radius(latm(2,j))) then
      nsh=nsh+1
      if(nsh.gt.100) stop 'increase dimension nsh' 
      ish(nsh)=i
      jsh(nsh)=j
      rsh(nsh)=dist
      endif
      endif
    2 continue
      endif
    1 continue

      number=0

      if(nsh.gt.0) then
      do 3 i=1,nsh-1
      do 4 j=i+1,nsh
      if(rsh(i).gt.rsh(j)) then
      dist=rsh(i)
      k=ish(i)
      l=jsh(i)
      rsh(i)=rsh(j)
      ish(i)=ish(j)
      jsh(i)=jsh(j)
      rsh(j)=dist
      ish(j)=k
      jsh(j)=l
      endif
    4 continue
    3 continue
      do 5 i=1,nsh
      do 6 j=1,number
      if(ish(i).eq.ishort(j).or.jsh(i).eq.jshort(j)) goto 5
    6 continue
      number=number+1
      if(number.gt.10) stop 'increase dimension number'
      ishort(number)=ish(i)
      jshort(number)=jsh(i)
      rshort(number)=rsh(i)
    5 continue
      endif

      prepare_short_list=number

      return
      end

      subroutine prepare_topology()

      use prepare_data

      implicit none

#include "inp.fh"

      write(lfnout,1000)
 1000 format(' ARGOS PREPARE TOPOLOGY',/)

      if(.not.lsqu) call prepare_sequence()

      call prepare_top_allocate()
      call prepare_read_sequence()
      call prepare_top_allocate2()
      call prepare_read_segments()
      call prepare_make_links()
      call prepare_parameters()

!     topology modifications
!     ----------------------

    1 continue
      if(.not.inp_a(item)) then
    2 continue
      if(.not.inp_read()) then
      item='end'
      return
      else
      if(.not.inp_a(item)) goto 2
      endif
      endif

      if(inp_compare(.false.,'modify',item)) then

      goto 1
      endif

      call prepare_write_topology()
      call prepare_top_deallocate()

      write(lfnout,444) item
  444 format('LEAVING TOP ',a)

      ltop=.true.

      return
      end

      subroutine prepare_top_allocate()

      use prepare_data

      implicit none

      integer len

!     get the dimensions from the sequence file

      len=index(filseq,' ')-1
      open(unit=lfnseq,file=filseq(1:len),form='formatted',
     & status='old',err=9999)
      rewind(lfnseq)
      read(lfnseq,1000) nseq,mseq
      read(lfnseq,1000) nsgm,msgm
      read(lfnseq,1000) nlnk,mlnk
      read(lfnseq,1000) nslv
 1000 format(4x,2i8)
      close(unit=lfnseq)

!     allocate memory for sequence

!     integer lseq(1,mseq) : number of sequence entry
!                  2       : link type
!                  3       : index of first atom of sequence entry
!                  4       : molecule number
!                  5       : index into unique segment list

!     char*5  cseq(1,mseq) : name of sequence entry on pdb
!                  2       : name of sequence entry on top

      allocate(lseq(6,mseq))
      allocate(cseq(2,mseq))

!     allocate memory for link list

!     integer llnk(1,mlnk) : link segment 1
!                  2       : link segment 2
!                  3       : link type : 0: normal
!                                        1: forced
!     char*4  clnk(1,mlnk) : link segment 1 atom name
!                  2       : link segment 2 atom name

      allocate(llnk(3,mlnk))
      allocate(clnk(2,mlnk))

!     allocate memory for the unique list of links

!     integer lsgl(1,msgl) : segment i index into sequence array lseq
!                  2       :         j
!                  3       : number of occurences of this link
!                  4       : index into bond list (only one per link possible)
!                  5       : number of angles involved in this link
!                  6       : index into angle list
!                  7       : number of torsions involved in this link
!                  8       : index into torsion list
!                  9       : number of impropers involved in this link
!                 10       : index into improper list
!                 11       : number of non-bonded pairs
!                 12       : index into non-bonded list

!     character*4 csgl(1,msgl) : link atom name in segment i
!                      2       :                           j

      msgl=mlnk
      allocate(lsgl(12,msgl))
c      if(.not.ma_push_get(mt_int,12*msgl,'lsgl',l_lsgl,i_lsgl))
c     & stop 'Memory allocation failed for lsgl'
      allocate(csgl(2,msgl))

!     allocate memory for unique segment list
!     ---------------------------------------

!     integer lsgm(1,msgm) : number of segments of this type
!                  2       :
!                  3       :

!     char*5  csgm(1,msgm) :
!                  2

      allocate(lsgm(3,msgm))
      allocate(csgm(2,msgm))

      return

 9999 stop 'Error reading seq file'
      return
      end

      subroutine prepare_top_allocate2()

      use prepare_data

      implicit none

!     adjust dimension to account for links

      mato=nato+1
      mbnd=nbnd+3*nseq+1
      mang=nang+27*nseq+1
      mdih=ndih+45*nseq+1
      mimp=nimp+6*nseq+1
      mmol=nmol
      mparms=nparms

      msato=nsato
      msbnd=nsbnd+3*nseq+1
      msang=nsang+27*nseq+1
      msdih=nsdih+45*nseq+1
      msimp=nsimp+6*nseq+1
      msnon=nsnon

      write(lfnout,1000) mseq,mato,mbnd,mang,mdih,mimp,mparms
 1000 format('list dimensions are determined:',/,
     & ' number of segments  ',i10,/,
     & ' number of atoms     ',i10,/,
     & ' number of bonds     ',i10,/,
     & ' number of angles    ',i10,/,
     & ' number of dihedrals ',i10,/,
     & ' number of impropers ',i10,//,
     & ' number of parameters',i10,/)

!     allocate memory for atomic lists

!     integer latm(1,matm)   : charge group
!                  2         : polarization group
!                  3         : link number
!                  4         : center type
!                  5         : segment number
!                  6         : molecule number
!                  7         : atomic number
!                  8         : fraction
!                  9         : ???

!     char*6  catm(  1,matm) : atom name 
!                  i+1       : atom type set i, i=1,nparms

      allocate(latm(11,matm))
      allocate(catm(mparms,matm))

!     allocate memory for the segments

!     integer lsndx(1,1,msgm) : number of atoms in segment
!                     2       : index into segment atom list
!                   2,1       : number of bonds in segment
!                     2       : index into segment bond list
!                   3,1       : number of angles in segment
!                     2       : index into segment angle list
!                   4,1       : number of torsions in segment
!                     2       : index into segment torsion list
!                   5,1       : number of impropers in segment
!                     2       : index into segment improper list
!                   6,1       : number of non-bondeds in segment
!                     2       : index into segment non-bonded list

      allocate(lsndx(6,2,msgm))

!     allocate memory for the segment atom list

!     integer    lsato(1,msato)   :
!                      2          :
!                      3          :
!                      4          :
!                      5          :
!                      6          : index to atom type set 1
!                      7          : index to atom type set 2
!                      8          : index to atom type set 3

!     character*5 csato(1,msato)  : atom name
!                       2         : atom type set 1
!                       3         : atom type set 2
!                       4         : atom type set 3

!     real*8      sato(1,msato,n) : charge in set n
!                      2          : polarizability in set n

      allocate(lsato(8,msato))
      allocate(csato(4,msato))
      allocate(sato(2,msato,3))

!     allocate memory for the segment bond list

!     integer lsbnd(1,msbnd) : atomi
!                   2        : atomj
!                   3        : constraint
!                   4        : database
!                   5        : atom list entry i
!                   6        : atom list entry j

!     real*8 sbnd(1,msbnd,n) : bond-distance set n
!                 2          : force constant set n

      allocate(lsbnd(6,msbnd))
      allocate(sbnd(2,msbnd,3))

!     allocate memory for the segment angle list

!     integer lsang(1,msang) : atomi
!                   2        : atomj
!                   3        : atomk
!                   4        : constraint
!                   5        : database
!                   6        : atom list entry i
!                   7        : atom list entry j
!                   8        : atom list entry k

!     real*8 sang(1,msang,n) : angle set n
!                 2          : force constant set n

      allocate(lsang(8,msang))
      allocate(sang(2,msang,3))

!     allocate memory for the segment torsion list

!     integer lsdih(1,msdih)    : atomi
!                   2           : atomj
!                   3           : atomk
!                   4           : atoml
!                   5           : constraint
!                   6           : database
!                   7           : multiplicity set 1
!                   8           : multiplicity set 2
!                   9           : multiplicity set 3
!                  10           : atom list entry i
!                  11           : atom list entry j
!                  12           : atom list entry k
!                  13           : atom list entry l
!                  14           : multiplicity set 1 duplicate 2
!                  15           : multiplicity set 2 duplicate 2
!                  16           : multiplicity set 3 duplicate 2
!                  17           : multiplicity set 1 duplicate 3
!                  18           : multiplicity set 2 duplicate 3
!                  19           : multiplicity set 3 duplicate 3

!     real*8 sdih(1,msdih,n,nd) : torsion angle set n (1:3) duplicate nd (1:3)
!                 2             : force constant set n (1:3) duliclate nd (1:3)

      allocate(lsdih(19,msdih))
      allocate(sdih(2,msdih,3,3))

!     allocate memory for the segment improper list

!     integer lsimp(1,msimp) : atomi
!                   2        : atomj
!                   3        : atomk
!                   4        : atoml
!                   5        : constraint
!                   6        : database
!                   7        : multiplicity set 1
!                   8        : multiplicity set 2
!                   9        : multiplicity set 3
!                  10        : atom list entry i
!                  11        : atom list entry j
!                  12        : atom list entry k
!                  13        : atom list entry l

!     real*8 simp(1,msimp,n) : improper torsion angle set n
!                 2          : force constant set n

      allocate(lsimp(13,msimp))
      allocate(simp(2,msimp,3))

!     allocate memory for the segment non-bonded list

!     integer lsnon(1,msnon) : atomi
!                   2        : atomj
!                   3        : 0 for regular, 1 for third neighbor

      allocate(lsnon(3,msnon))

      return
      end

      subroutine prepare_top_deallocate()

      use prepare_data

      implicit none

!      call ma_summarize_allocated_blocks()

      deallocate(ratt)
      deallocate(patt)
      deallocate(catt)
      deallocate(latt)
      deallocate(lsnon)
      deallocate(simp)
      deallocate(lsimp)
      deallocate(sdih)
      deallocate(lsdih)
      deallocate(sang)
      deallocate(lsang)
      deallocate(sbnd)
      deallocate(lsbnd)
      deallocate(sato)
      deallocate(csato)
      deallocate(lsato)
      deallocate(lsndx)
      deallocate(catm)
      deallocate(latm)
      deallocate(csgm)
      deallocate(lsgm)
      deallocate(csgl)
      deallocate(lsgl)
c      if(.not.ma_pop_stack(l_lsgl))
c     & stop 'Memory deallocation failed for lsgl'
      deallocate(clnk)
      deallocate(llnk)
      deallocate(cseq)
      deallocate(lseq)

      return
      end

      subroutine prepare_read_sequence()

      use prepare_data

      implicit none

      integer i,j,iseq,ilnk,imol,len,lens,isgm,jsgm
      integer nas,nbs,nhs,nds,nis,nps,nns
      character*80 card
      character*4 string
      character*5 sgmnam
      real*8 versgm

      len=index(filseq,' ')-1
      open(unit=lfnseq,file=filseq(1:len),form='formatted',
     & status='old',err=9999)

      rewind(lfnseq)
      read(lfnseq,1000) string
      read(lfnseq,1000) string
      read(lfnseq,1000) string
      read(lfnseq,1000) string
 1000 format(a4)

      iseq=0
      ilnk=0
      imol=1

    1 continue
      read(lfnseq,1001,end=9999,err=9999) card
 1001 format(a)
      if(card(1:1).eq.'#') goto 1

      if(card(1:5).eq.'break') then
      if(iseq.gt.0) lseq(2,iseq)=1
      goto 1
      endif
      if(card(1:8).eq.'fraction') then
      imol=-(iabs(imol)+1)
      if(iseq.gt.0) lseq(2,iseq)=3
      goto 1
      endif
      if(card(1:4).eq.'link') then
      ilnk=ilnk+1
      if(ilnk.gt.mlnk) stop 'increase dimension mlnk'
      read(card,1002,err=9999) (llnk(j,ilnk),clnk(j,ilnk),j=1,2)
 1002 format(5x,i5,a4,i5,a4)
      llnk(3,ilnk)=0
      write(lfnout,555) ilnk,(llnk(j,ilnk),clnk(j,ilnk),j=1,2)
  555 format('SEQLINK ',i5,2(i5,1x,a))
      goto 1
      endif
      if(card(1:4).eq.'LINK') then
      ilnk=ilnk+1
      if(ilnk.gt.mlnk) stop 'increase dimension mlnk'
      read(card,1002,err=9999) (llnk(j,ilnk),clnk(j,ilnk),j=1,2)
      llnk(3,ilnk)=1
      goto 1
      endif
      if(card(1:8).eq.'molecule') then
      imol=iabs(imol)+1
      if(iseq.gt.0) lseq(2,iseq)=2
      goto 1
      endif
      if(card(1:3).eq.'pmf') then
      goto 1
      endif
      if(card(1:6).eq.'repeat') then
      goto 1
      endif
      if(card(1:7).eq.'solvent') then
      do 23 i=1,nslv
      read(lfnseq,1001,end=9999,err=9999) card
      if(iseq+i.gt.mseq) stop 'increase dimension mseq'
      read(card,1003,err=9999) lseq(1,iseq+i),cseq(1,iseq+i)
      lseq(2,iseq+i)=-2
      lseq(4,iseq+i)=0
   23 continue
      goto 1
      endif
      if(card(1:4).ne.'stop') then
      iseq=iseq+1
      if(iseq.gt.mseq) stop 'increase dimension mseq'
      read(card,1003,err=9999) lseq(1,iseq),cseq(1,iseq)
 1003 format(i5,a5)
      lseq(2,iseq)=0
      lseq(4,iseq)=imol
      write(lfnout,2999) iseq,(lseq(i,iseq),i=1,6),cseq(1,iseq)
 2999 format('SEQ ',7i6,1x,a5)
      if(iseq+1.gt.mseq) stop 'increase dimension mseq'
      cseq(1,iseq+1)='          '
      lseq(1,iseq+1)=0
      lseq(2,iseq+1)=0
      lseq(3,iseq+1)=0
      lseq(4,iseq+1)=0
      lseq(5,iseq+1)=0
      lseq(6,iseq+1)=0
      imol=iabs(imol)
      goto 1
      endif
      close(unit=lfnseq)

!     determine termini based on sequence list ( not the links yet! )

!     -1 : N-terminus
!     -2 : integral molecule
!     >0 : C-terminus

      if(iseq.gt.0) then
      if(lseq(2,1).eq.0) lseq(2,1)=-1
      if(lseq(2,1).eq.2) lseq(2,1)=-2
      if(iseq.eq.1) lseq(2,1)=-2
      if(lseq(2,iseq).eq.0) lseq(2,iseq)=1
      do 2 i=2,iseq
      if(lseq(2,i).eq.0.and.lseq(2,i-1).gt.0) lseq(2,i)=-1
      if(lseq(2,i).eq.-1.and.lseq(2,i-1).eq.0) lseq(2,i-1)=1
      if(lseq(2,i).eq.-1.and.lseq(2,i-1).eq.-1) lseq(2,i-1)=-2
      if(lseq(2,i).gt.0.and.lseq(2,i-1).eq.-2) lseq(2,i)=-2
      if(lseq(2,i).gt.0.and.lseq(2,i-1).gt.0) lseq(2,i)=-2
    2 continue
      endif

      nseq=iseq
      nmol=imol
      nlnk=ilnk

!     determine the terminal segments

      do 3 i=1,nlnk

      isgm=0
      jsgm=0
      do 4 j=1,nseq
      if(lseq(1,j).eq.llnk(1,i)) isgm=j
      if(lseq(1,j).eq.llnk(2,i)) jsgm=j
    4 continue
      if(isgm.eq.0.or.jsgm.eq.0) stop 'Error in link'

      write(lfnout,1004) llnk(1,i),clnk(1,i),llnk(2,i),clnk(2,i)
 1004 format(' Link ',i5,':',a4,4x,i5,':',a4)

!     check if segment atom can be a link

      call prepare_sgm_atm_scan(cseq(1,isgm),clnk(1,i))

      if(link.eq.1) then
      if(lseq(2,isgm).eq.-1) lseq(2,isgm)=0
      if(lseq(2,isgm).eq.-2) lseq(2,isgm)=1
      endif
      if(link.eq.2) then
      if(lseq(2,isgm).eq.-2) lseq(2,isgm)=-1
      if(lseq(2,isgm).gt.0) lseq(2,isgm)=0
      endif

!     check if segment atom can be a link

      call prepare_sgm_atm_scan(cseq(1,jsgm),clnk(2,i))

      if(link.eq.1) then
      if(lseq(2,jsgm).eq.-1) lseq(2,jsgm)=0
      if(lseq(2,jsgm).eq.-2) lseq(2,jsgm)=1
      endif
      if(link.eq.2) then
      if(lseq(2,jsgm).eq.-2) lseq(2,jsgm)=-1
      if(lseq(2,jsgm).gt.0) lseq(2,jsgm)=0
      endif

    3 continue

!     determine the list of unique segments

      nsgm=1
      csgm(1,1)=cseq(1,1)
      lsgm(1,1)=1
      lseq(5,1)=1
      do 5 i=2,nseq+nslv
      do 6 j=1,nsgm
      if(csgm(1,j).eq.cseq(1,i)) then
      lsgm(1,j)=lsgm(1,j)+1
      lseq(5,i)=j
      goto 5
      endif
    6 continue
      nsgm=nsgm+1
      if(nsgm.gt.msgm) stop 'msgm problem'
      csgm(1,nsgm)=cseq(1,i)
      lsgm(1,nsgm)=1
      lseq(5,i)=nsgm
    5 continue

!     get the dimensions from the segment files

      write(lfnout,2000) nsgm
 2000 format('Unique segments list',i5,/)

      nns=0

      nato=0
      nbnd=0
      nang=0
      ndih=0
      nimp=0

      nsato=0
      nsbnd=0
      nsang=0
      nsdih=0
      nsimp=0

      do 7 i=1,nsgm

      sgmnam=csgm(1,i)
      lens=index(sgmnam,' ')-1
      if(lens.le.0) lens=5

      do 8 j=mdirpar,1,-1
      if(nfilpar(j).gt.0) then
      filsgm=
     & dirpar(j)(1:index(dirpar(j),' ')-1)//sgmnam(1:lens)//'.sgm '
      len=index(filsgm,' ')-1
      open(unit=lfnsgm,file=filsgm(1:len),form='formatted',
     & status='old',err=8)
      rewind(unit=lfnsgm)
      goto 9
      endif
    8 continue
      stop 'Could not find sgm file at 1'
    9 continue

   10 continue
      read(lfnsgm,2001,err=9998,end=9998) card
 2001 format(a)
      if(card(1:1).eq.'#'.or.card(1:1).eq.'$') goto 10
      read(card,2002) versgm
 2002 format(f12.6)
      read(lfnsgm,2003,err=9998) nas,nbs,nhs,nds,nis,nps
 2003 format(5i5,5x,i5)
      close(unit=lfnsgm)

      nparms=max(nparms,nps)
      nns=max(nns,nas)
      nsato=nsato+nas
      nsbnd=nsbnd+nbs
      nsang=nsang+nhs
      nsdih=nsdih+nds
      nsimp=nsimp+nis

      nato=nato+lsgm(1,i)*nas
      nbnd=nbnd+lsgm(1,i)*nbs
      nang=nang+lsgm(1,i)*nhs
      ndih=ndih+lsgm(1,i)*nds
      nimp=nimp+lsgm(1,i)*nis

      write(lfnout,2004) i,lsgm(1,i),csgm(1,i),nas,nbs,nhs,nds,nis,nps
 2004 format(2i6,1x,a5,6i6)
    7 continue

      matm=nsato
      nsnon=nsgm*nns*nns*4

      write(lfnout,2005) nseq
 2005 format('Segments list a',i5,/)
      do 11 i=1,nseq
      lseq(3,i)=0
      write(lfnout,2006) i,(lseq(j,i),j=1,5),cseq(1,i)
 2006 format(6i6,1x,2a5)
   11 continue

      return

 9999 stop 'Error reading seq file'
 9998 stop 'Error reading seq file'
      return
      end

      subroutine prepare_sgm_atm_scan(sgmnam,atmnam)

      use prepare_data

      implicit none

      character*5 sgmnam
      character*4 atmnam

      integer i,j,len,lens,num,ilnk
      character*6 name
      character*80 card
      real*8 versgm

      lens=index(sgmnam,' ')-1
      if(lens.le.0) lens=5

      do 5 i=mdirpar,1,-1
      if(nfilpar(i).gt.0) then
      filsgm=
     & dirpar(i)(1:index(dirpar(i),' ')-1)//sgmnam(1:lens)//'.sgm '
      len=index(filsgm,' ')-1
      open(unit=lfnsgm,file=filsgm(1:len),form='formatted',
     & status='old',err=5)
      rewind(unit=lfnsgm)
      goto 55
      endif
    5 continue
      write(lfnout,8888) filsgm(1:len)
 8888 format(a)
      stop 'Could not find sgm file at 2'
   55 continue

      num=0
      link=0
    6 continue
      read(lfnsgm,1000,err=9997,end=9997) card
 1000 format(a)
      if(card(1:1).eq.'#'.or.card(1:1).eq.'$') goto 6
      read(card,1001,err=9997) versgm
 1001 format(f12.6)
      read(lfnsgm,1002,err=9997) natm,npar
 1002 format(i5,25x,i5)
      do 7 i=1,npar
      read(lfnsgm,1000,err=9997,end=9997) card
    7 continue
      do 8 i=1,natm
      read(lfnsgm,1003) name,ilnk 
 1003 format(5x,a6,10x,i5)
      if(name(1:4).eq.atmnam) then
      link=ilnk
      num=i
      rewind(unit=lfnsgm)
      close(unit=lfnsgm)
      return
      endif
      do 9 j=1,npar
      read(lfnsgm,1000,err=9997,end=9997) card
    9 continue
    8 continue
      close(unit=lfnsgm)
      stop 'Error reading sgm file'

      return

 9998 stop 'Could not find sgm file at 3'
 9997 stop 'Error reading sgm file'
      return
      end

      subroutine prepare_read_segments()

      use prepare_data

      implicit none

!      real*8 sato(2,msato,3),sbnd(2,msbnd,3),sang(2,msang,3),
!     & sdih(2,msdih,3,3),simp(2,msimp,3)

      integer i,ii,iii,j,jj,k,m,len,lens
      integer nas,nbs,nhs,nds,nis,nzs,nps,ipd
      character*5 sgmnam
      character*80 card
      real*8 versgm
      integer iao,ibo,iho,ido,iio

      iao=0
      ibo=0
      iho=0
      ido=0
      iio=0

      do 1 i=1,nsgm
      sgmnam=csgm(1,i)
      lens=index(sgmnam,' ')-1
      if(lens.le.0) lens=5

      do 2 j=mdirpar,1,-1
      if(nfilpar(j).gt.0) then
      filsgm=
     & dirpar(j)(1:index(dirpar(j),' ')-1)//sgmnam(1:lens)//'.sgm '
      len=index(filsgm,' ')-1
      open(unit=lfnsgm,file=filsgm(1:len),form='formatted',
     & status='old',err=2)
      rewind(unit=lfnsgm)
      goto 3
      endif
    2 continue
      write(lfnout,8888) filsgm(1:len)
 8888 format(a)
      stop 'Could not find sgm file at 4'
    3 continue

    4 continue
      read(lfnsgm,1000) card
 1000 format(a)
      if(card(1:1).eq.'#'.or.card(1:1).eq.'$') goto 4
      read(card,1001,err=9999) versgm
 1001 format(f12.6)
      read(lfnsgm,1002,err=9999) nas,nbs,nhs,nds,nis,nzs,nps,ipd
 1002 format(8i5)
      if(ipd.eq.0) ipardef=1
      if(nps.gt.nparms) stop 'Error in number par sets'
      do 5 j=1,nps
      read(lfnsgm,1003) wcorr(j)
 1003 format(f12.6)
    5 continue
      do 6 j=nps+1,nparms
      wcorr(j)=wcorr(nps)
    6 continue

      if(iao+nas.gt.msato) stop 'Increase dimension msato'
      if(ibo+nbs.gt.msbnd) stop 'Increase dimension msbnd'
      if(iho+nhs.gt.msang) stop 'Increase dimension msang'
      if(ido+nds.gt.msdih) stop 'Increase dimension msdih'
      if(iio+nis.gt.msimp) stop 'Increase dimension msimp'

      do 7 j=1,nas
      read(lfnsgm,1004) csato(1,iao+j),(lsato(k,iao+j),k=1,5)
 1004 format(5x,a5,1x,5i5)
      do 8 m=1,ipd
      read(lfnsgm,1005) csato(1+m,iao+j),(sato(k,iao+j,1),k=1,2)
 1005 format(5x,a5,1x,2f12.6)
    8 continue
      do 9 m=ipd+1,3
      sato(1,iao+j,m)=sato(1,iao+j,m-1)
      sato(2,iao+j,m)=sato(2,iao+j,m-1)
      csato(1+m,iao+j)=csato(m,iao+j)
    9 continue
    7 continue
      lsndx(1,1,i)=nas
      lsndx(1,2,i)=iao+1
      iao=iao+nas

      do 10 j=1,nbs
      read(lfnsgm,1006) (lsbnd(k,ibo+j),k=1,4)
 1006 format(5x,4i5)
      do 11 m=1,ipd
      read(lfnsgm,1007) (sbnd(k,ibo+j,m),k=1,2)
 1007 format(f12.6,e12.5)
   11 continue
      do 12 m=ipd+1,3
      sbnd(1,ibo+j,m)=sbnd(1,ibo+j,m-1)
      sbnd(2,ibo+j,m)=sbnd(2,ibo+j,m-1)
   12 continue
   10 continue
      lsndx(2,1,i)=nbs
      lsndx(2,2,i)=ibo+1
      ibo=ibo+nbs

      do 13 j=1,nhs
      read(lfnsgm,1008) (lsang(k,iho+j),k=1,5)
 1008 format(5x,5i5)
      do 14 m=1,ipd
      read(lfnsgm,1009) (sang(k,iho+j,m),k=1,2)
 1009 format(f12.6,e12.5)
   14 continue
      do 15 m=ipd+1,3
      sang(1,iho+j,m)=sang(1,iho+j,m-1)
      sang(2,iho+j,m)=sang(2,iho+j,m-1)
   15 continue
   13 continue
      lsndx(3,1,i)=nhs
      lsndx(3,2,i)=iho+1
      iho=iho+nhs

      do 16 j=1,nds
      read(lfnsgm,1010) (lsdih(k,ido+j),k=1,6)
 1010 format(5x,6i5)
      do 17 m=1,ipd
      read(lfnsgm,1011) lsdih(6+m,ido+j),(sdih(k,ido+j,m,1),k=1,2)
 1011 format(i3,f12.6,e12.5)
   17 continue
      do 18 m=ipd+1,3
      sdih(1,ido+j,m,1)=sdih(1,ido+j,m-1,1)
      sdih(2,ido+j,m,1)=sdih(2,ido+j,m-1,1)
      lsdih(6+m,ido+j)=lsdih(5+m,ido+j)
   18 continue
   16 continue
      lsndx(4,1,i)=nds
      lsndx(4,2,i)=ido+1
      ido=ido+nds

      do 19 j=1,nis
      read(lfnsgm,1012) (lsimp(k,iio+j),k=1,6)
 1012 format(5x,6i5)
      do 20 m=1,ipd
      read(lfnsgm,1013) lsimp(6+m,iio+j),(simp(k,iio+j,m),k=1,2)
 1013 format(i3,f12.6,e12.5)
   20 continue
      do 21 m=ipd+1,3
      simp(1,iio+j,m)=simp(1,iio+j,m-1)
      simp(2,iio+j,m)=simp(2,iio+j,m-1)
      lsimp(6+m,iio+j)=lsimp(5+m,iio+j)
   21 continue
   19 continue
      lsndx(5,1,i)=nis
      lsndx(5,2,i)=iio+1
      iio=iio+nis

      close(unit=lfnsgm)

    1 continue

      nsato=iao
      nsbnd=ibo
      nsang=iho
      nsdih=ido
      nsimp=iio

!     Count the number of unique atom types

      natt=0
      do 22 i=1,nsato
      do 23 ii=1,nparms
      do 24 j=1,i-1
      do 25 jj=1,nparms
      if(csato(ii+1,i).eq.csato(jj+1,j)) goto 23
   25 continue
   24 continue
      do 26 iii=1,ii-1
      if(csato(ii+1,i).eq.csato(iii+1,i)) goto 23
   26 continue
      natt=natt+1
   23 continue
   22 continue
      matt=natt

      write(lfnout,2022) matt
 2022 format(' Number of unique atom types is',i6)

!     Count the number of unique non-bonded atom pairs from unlinked segments

      nunon=0
      do 27 i=1,nsgm
      do 28 j=i,nsgm
      nunon=nunon+lsndx(1,1,i)*lsndx(1,1,j)
   28 continue
   27 continue

!     Allocate memory for the atom type list

      allocate(latt(3,matt))
      allocate(catt(2,matt))
      allocate(patt(4,2,matt,matt))
      allocate(ratt(matt))

      return

 9999 stop 'Error reading sgm file'
      return
      end

      subroutine prepare_make_links()

      use prepare_data

      implicit none

c      integer lsgl(12,msgl)

      integer i,ii,iii,j,jj,k,m,isgm,jsgm,ioff,joff
      logical found

      write(lfnout,2005) nseq
 2005 format('Segments list b',i5,/)
      do 1199 i=1,nseq
      lseq(3,i)=0
      write(lfnout,2006) i,(lseq(j,i),j=1,5),cseq(1,i)
 2006 format(6i6,1x,2a5)
 1199 continue

!     Change links to point from segment id to list index

      do 1 i=1,nlnk
      do 2 j=1,nseq
      if(llnk(1,i).eq.lseq(1,j)) then
      llnk(1,i)=j
      goto 3
      endif
    2 continue
      stop 'segment in explicit link not found'
    3 continue
      do 4 j=1,nseq
      if(llnk(2,i).eq.lseq(1,j)) then
      llnk(2,i)=j
      goto 1111
      endif
    4 continue
      stop 'segment in explicit link not found'
 1111 continue
      write(lfnout,545) i,(llnk(j,i),clnk(j,i),j=1,2)
  545 format('EXPLINK ',i5,2(i5,1x,a))
    1 continue

!     Add the chain links

      do 5 i=2,nseq
      write(lfnout,288) i,lseq(2,i-1),lseq(2,i)
  288 format('CHAINLINK ',3i6)
      if((lseq(2,i-1).eq.-1.or.lseq(2,i-1).eq.0).and.
     & (lseq(2,i).eq.0.or.lseq(2,i).eq.1.or.lseq(2,i).eq.2)) then
      nlnk=nlnk+1
      if(nlnk.gt.mlnk) stop 'Increase dimension mlnk'
      llnk(1,nlnk)=i-1
      llnk(2,nlnk)=i
      llnk(3,nlnk)=0
      isgm=lseq(5,i-1)
      jsgm=lseq(5,i)
      ioff=lsndx(1,2,isgm)-1
      joff=lsndx(1,2,jsgm)-1
      found=.false.
      do 6 j=1,lsndx(1,1,isgm)
      if(lsato(1,ioff+j).eq.2) then
      clnk(1,nlnk)=csato(1,ioff+j)(1:4)
      found=.true.
      endif
    6 continue
      if(found) then
      found=.false.
      do 7 j=1,lsndx(1,1,jsgm)
      if(lsato(1,joff+j).eq.1) then
      clnk(2,nlnk)=csato(1,joff+j)(1:4)
      found=.true.
      endif
    7 continue
      endif
      if(.not.found) nlnk=nlnk-1
      endif
    5 continue

!     Make list of unique links

      nsgl=0
      do 8 i=1,nlnk
      write(lfnout,535) i,(llnk(j,i),clnk(j,i),j=1,2)
  535 format(/,'UNQLINK ',i5,2(i5,1x,a))
      do 9 j=1,nsgl
      write(lfnout,565) j,csgm(1,lsgl(1,j)),csgm(1,lsgl(2,j)),
     & csgl(1,j),csgl(2,j)
  565 format('TEST ',i5,4(1x,a))
      if(cseq(1,llnk(1,i)).eq.csgm(1,lsgl(1,j)).and.
     & cseq(1,llnk(2,i)).eq.csgm(1,lsgl(2,j)).and.
     & clnk(1,i).eq.csgl(1,j).and.clnk(2,i).eq.csgl(2,j)) then
      lsgl(3,j)=lsgl(3,j)+1
      llnk(3,i)=j
      goto 8888
      endif
    9 continue
      write(lfnout,575)
  575 format('found')
      nsgl=nsgl+1
      if(nsgl.gt.msgl) stop 'Increase dimension msgl'
      lsgl(1,nsgl)=lseq(5,llnk(1,i))
      lsgl(2,nsgl)=lseq(5,llnk(2,i))
      lsgl(3,nsgl)=1
      lsgl(4,nsgl)=0
      lsgl(5,nsgl)=0
      lsgl(6,nsgl)=0
      lsgl(7,nsgl)=0
      lsgl(8,nsgl)=0
      lsgl(9,nsgl)=0
      lsgl(10,nsgl)=0
      lsgl(11,nsgl)=0
      lsgl(12,nsgl)=0
      csgl(1,nsgl)=clnk(1,i)
      csgl(2,nsgl)=clnk(2,i)
      llnk(3,i)=nsgl
      write(lfnout,585) nsgl,(lsgl(j,nsgl),j=1,12),
     & csgl(1,nsgl),csgl(2,nsgl)
  585 format('NEWSGL ',13i5,2(1x,a))
 8888 continue
      write(lfnout,595) i,(llnk(j,i),clnk(j,i),j=1,2),llnk(3,i)
  595 format(/,'NEWLINK ',i5,2(i5,1x,a),i5)
    8 continue

!     Add the links to the bond list

      do 10 i=1,nsgl
      write(lfnout,3333) i,lsgl(1,i),lsgl(2,i),
     & lsndx(1,1,lsgl(1,i)),lsndx(1,1,lsgl(2,i)),csgl(1,i),csgl(2,i)
 3333 format('NSGL ',5i5,2(1x,a))
      nsbnd=nsbnd+1
      if(nsbnd.gt.msbnd) stop 'Increase dimension msbnd'

!     loop over the number of atoms in segment pointed to by lsgl(1,i)

      do 11 j=1,lsndx(1,1,lsgl(1,i))
      if(csato(1,lsndx(1,2,lsgl(1,i))-1+j)(1:4).eq.csgl(1,i)) then
      lsbnd(1,nsbnd)=-j
      goto 12
      endif
   11 continue
      stop 'Could not find atom i for link'
   12 continue

!     loop over the number of atoms in segment pointed to by lsgl(2,i)

      do 13 j=1,lsndx(1,1,lsgl(2,i))
      if(csato(1,lsndx(1,2,lsgl(2,i))-1+j)(1:4).eq.csgl(2,i)) then
      lsbnd(2,nsbnd)=j
      goto 14
      endif
   13 continue
      stop 'Could not find atom j for link'
   14 continue
      lsbnd(3,nsbnd)=0
      lsbnd(4,nsbnd)=0
      lsbnd(5,nsbnd)=0
      lsbnd(6,nsbnd)=0
      lsgl(4,i)=nsbnd
   10 continue

!     Add the angles involving links to the angle list

      do 15 i=1,nsgl
      lsgl(5,i)=0
      lsgl(6,i)=nsang+1

!     loop over the number of bonds in segment pointed to by lsgl(1,i)

      do 16 j=1,lsndx(2,1,lsgl(1,i))
      if(lsbnd(1,lsndx(2,2,lsgl(1,i))-1+j).eq.-lsbnd(1,lsgl(4,i))) then
      lsgl(5,i)=lsgl(5,i)+1
      nsang=nsang+1
      lsang(1,nsang)=-lsbnd(2,lsndx(2,2,lsgl(1,i))-1+j)
      lsang(2,nsang)=lsbnd(1,lsgl(4,i))
      lsang(3,nsang)=lsbnd(2,lsgl(4,i))
      elseif
     & (lsbnd(2,lsndx(2,2,lsgl(1,i))-1+j).eq.-lsbnd(1,lsgl(4,i))) then
      lsgl(5,i)=lsgl(5,i)+1
      nsang=nsang+1
      lsang(1,nsang)=-lsbnd(1,lsndx(2,2,lsgl(1,i))-1+j)
      lsang(2,nsang)=lsbnd(1,lsgl(4,i))
      lsang(3,nsang)=lsbnd(2,lsgl(4,i))
      endif
   16 continue

!     loop over the number of bonds in segment pointed to by lsgl(2,i)

      do 17 j=1,lsndx(2,1,lsgl(2,i))
      if(lsbnd(1,lsndx(2,2,lsgl(2,i))-1+j).eq.lsbnd(2,lsgl(4,i))) then
      lsgl(5,i)=lsgl(5,i)+1
      nsang=nsang+1
      lsang(1,nsang)=lsbnd(1,lsgl(4,i))
      lsang(2,nsang)=lsbnd(2,lsgl(4,i))
      lsang(3,nsang)=lsbnd(2,lsndx(2,2,lsgl(2,i))-1+j)
      elseif
     & (lsbnd(2,lsndx(2,2,lsgl(2,i))-1+j).eq.lsbnd(2,lsgl(4,i))) then
      lsgl(5,i)=lsgl(5,i)+1
      nsang=nsang+1
      lsang(1,nsang)=lsbnd(1,lsgl(4,i))
      lsang(2,nsang)=lsbnd(2,lsgl(4,i))
      lsang(3,nsang)=lsbnd(1,lsndx(2,2,lsgl(2,i))-1+j)
      endif
   17 continue
   15 continue

!     Add the torsions involving links to the torsion list

      do 18 i=1,nsgl
      lsgl(7,i)=0
      lsgl(8,i)=nsdih+1

!     loop over the number of angles involved in this link

      do 19 j=1,lsgl(5,i)

!     loop over the number of bonds in segment pointed to by lsgl(1,i)

      do 20 k=1,lsndx(2,1,lsgl(1,i))
      if(lsbnd(1,lsndx(2,2,lsgl(1,i))-1+k).eq.-lsang(1,lsgl(6,i)-1+j)
     & .and.(lsang(2,lsgl(6,i)-1+j).gt.0.or.
     & lsang(2,lsgl(6,i)-1+j).ne.-lsbnd(2,lsndx(2,2,lsgl(1,i))-1+k)))
     & then
      lsgl(7,i)=lsgl(7,i)+1
      nsdih=nsdih+1
      lsdih(1,nsdih)=-lsbnd(2,lsndx(2,2,lsgl(1,i))-1+k)
      lsdih(2,nsdih)=lsang(1,lsgl(6,i)-1+j)
      lsdih(3,nsdih)=lsang(2,lsgl(6,i)-1+j)
      lsdih(4,nsdih)=lsang(3,lsgl(6,i)-1+j)
      elseif
     & (lsbnd(2,lsndx(2,2,lsgl(1,i))-1+k).eq.-lsang(1,lsgl(6,i)-1+j)
     & .and.(lsang(2,lsgl(6,i)-1+j).gt.0.or.
     & lsang(2,lsgl(6,i)-1+j).ne.-lsbnd(1,lsndx(2,2,lsgl(1,i))-1+k)))
     & then
      lsgl(7,i)=lsgl(7,i)+1
      nsdih=nsdih+1
      lsdih(1,nsdih)=-lsbnd(1,lsndx(2,2,lsgl(1,i))-1+k)
      lsdih(2,nsdih)=lsang(1,lsgl(6,i)-1+j)
      lsdih(3,nsdih)=lsang(2,lsgl(6,i)-1+j)
      lsdih(4,nsdih)=lsang(3,lsgl(6,i)-1+j)
      endif
   20 continue

!     loop over the number of bonds in segment pointed to by lsgl(2,i)

      do 21 k=1,lsndx(2,1,lsgl(2,i))
      if(lsbnd(1,lsndx(2,2,lsgl(2,i))-1+k).eq.lsang(3,lsgl(6,i)-1+j)
     & .and.(lsang(2,lsgl(6,i)-1+j).gt.0.and.
     & lsang(2,lsgl(6,i)-1+j).ne.lsbnd(2,lsndx(2,2,lsgl(2,i))-1+k)))
     & then
      lsgl(7,i)=lsgl(7,i)+1
      nsdih=nsdih+1
      lsdih(1,nsdih)=lsang(1,lsgl(6,i)-1+j)
      lsdih(2,nsdih)=lsang(2,lsgl(6,i)-1+j)
      lsdih(3,nsdih)=lsang(3,lsgl(6,i)-1+j)
      lsdih(4,nsdih)=lsbnd(2,lsndx(2,2,lsgl(2,i))-1+k)
      elseif
     & (lsbnd(2,lsndx(2,2,lsgl(2,i))-1+k).eq.lsang(3,lsgl(6,i)-1+j)
     & .and.(lsang(2,lsgl(6,i)-1+j).gt.0.and.
     & lsang(2,lsgl(6,i)-1+j).ne.lsbnd(1,lsndx(2,2,lsgl(2,i))-1+k)))
     & then
      lsgl(7,i)=lsgl(7,i)+1
      nsdih=nsdih+1
      lsdih(1,nsdih)=lsang(1,lsgl(6,i)-1+j)
      lsdih(2,nsdih)=lsang(2,lsgl(6,i)-1+j)
      lsdih(3,nsdih)=lsang(3,lsgl(6,i)-1+j)
      lsdih(4,nsdih)=lsbnd(1,lsndx(2,2,lsgl(2,i))-1+k)
      endif
   21 continue
   19 continue
   18 continue

!     Add the impropers involving links to the improper list

      do 22 i=1,nsgl
      lsgl(9,i)=0
      lsgl(10,i)=nsimp+1

      if(lsato(2,lsndx(1,2,lsgl(1,i))-1-lsbnd(1,lsgl(4,i))).eq.1) then
      do 23 j=1,lsndx(3,1,lsgl(1,i))
      if(lsang(2,lsndx(3,2,lsgl(1,i))-1+j).eq.-lsbnd(1,lsgl(4,i))) then
      lsgl(9,i)=lsgl(9,i)+1
      nsimp=nsimp+1
      if(nsimp.gt.msimp) stop 'Increase dimension msimp'
      lsimp(1,nsimp)=-lsang(1,lsndx(3,2,lsgl(1,i))-1+j)
      lsimp(2,nsimp)=-lsang(3,lsndx(3,2,lsgl(1,i))-1+j)
      lsimp(3,nsimp)=-lsang(2,lsndx(3,2,lsgl(1,i))-1+j)
      lsimp(4,nsimp)=lsbnd(2,lsgl(4,i))
      goto 24
      endif
   23 continue
   24 continue
      endif
      if(lsato(2,lsndx(1,2,lsgl(2,i))-1+lsbnd(2,lsgl(4,i))).eq.1) then
      do 25 j=1,lsndx(3,1,lsgl(2,i))
      if(lsang(2,lsndx(3,2,lsgl(2,i))-1+j).eq.lsbnd(2,lsgl(4,i))) then
      lsgl(9,i)=lsgl(9,i)+1
      nsimp=nsimp+1
      if(nsimp.gt.msimp) stop 'Increase dimension msimp'
      lsimp(1,nsimp)=lsang(1,lsndx(3,2,lsgl(2,i))-1+j)
      lsimp(2,nsimp)=lsang(3,lsndx(3,2,lsgl(2,i))-1+j)
      lsimp(3,nsimp)=lsang(2,lsndx(3,2,lsgl(2,i))-1+j)
      lsimp(4,nsimp)=lsbnd(1,lsgl(4,i))
      goto 26
      endif
   25 continue
   26 continue
      endif
   22 continue

!     Make the non-bonded lists

      nsnon=0
      do 27 i=1,nsgm
      lsndx(6,1,i)=0
      lsndx(6,2,i)=nsnon+1
      if(nsnon.gt.msnon+lsndx(1,1,i)*lsndx(1,1,i))
     & stop 'Increase dimension msnon'
      do 28 j=1,lsndx(1,1,i)-1
      do 29 k=j+1,lsndx(1,1,i)
      do 30 m=1,lsndx(2,1,i)
      if((lsbnd(1,lsndx(2,2,i)-1+m).eq.j.and.
     & lsbnd(2,lsndx(2,2,i)-1+m).eq.k).or.
     & (lsbnd(1,lsndx(2,2,i)-1+m).eq.k.and.
     & lsbnd(2,lsndx(2,2,i)-1+m).eq.j)) goto 29
   30 continue
      do 31 m=1,lsndx(3,1,i)
      if((lsang(1,lsndx(3,2,i)-1+m).eq.j.and.
     & lsang(3,lsndx(3,2,i)-1+m).eq.k).or.
     & (lsang(1,lsndx(3,2,i)-1+m).eq.k.and.
     & lsang(3,lsndx(3,2,i)-1+m).eq.j)) goto 29
   31 continue
      nsnon=nsnon+1
      lsndx(6,1,i)=lsndx(6,1,i)+1
      lsnon(1,nsnon)=j
      lsnon(2,nsnon)=k
      lsnon(3,nsnon)=0
      do 32 m=1,lsndx(4,1,i)
      if((lsdih(1,lsndx(4,2,i)-1+m).eq.j.and.
     & lsdih(4,lsndx(4,2,i)-1+m).eq.k).or.
     & (lsdih(1,lsndx(4,2,i)-1+m).eq.k.and.
     & lsdih(4,lsndx(4,2,i)-1+m).eq.j)) lsnon(3,nsnon)=1
   32 continue
   29 continue
   28 continue
   27 continue

!     Add the non-bonded list for linked segments

      do 33 i=1,nsgl
      lsgl(11,i)=0
      lsgl(12,i)=nsnon+1
      do 34 j=1,lsndx(1,1,lsgl(1,i))
      do 35 k=1,lsndx(1,1,lsgl(2,i))
      if(lsbnd(1,lsgl(4,i)).eq.-j.and.lsbnd(2,lsgl(4,i)).eq.k) goto 35
      do 36 m=1,lsgl(5,i)
      if(lsang(1,lsgl(6,i)-1+m).eq.-j.and.lsang(3,lsgl(6,i)-1+m).eq.k)
     & goto 35
   36 continue
      ii=0
      do 37 m=1,lsgl(7,i)
      if(lsdih(1,lsgl(8,i)-1+m).eq.-j.and.lsdih(4,lsgl(8,i)-1+m).eq.k)
     & ii=1
   37 continue
      nsnon=nsnon+1
      if(nsnon.gt.msnon) stop 'Increase dimension msnon'
      lsgl(11,i)=lsgl(11,i)+1
      lsnon(1,nsnon)=j
      lsnon(2,nsnon)=k
      lsnon(3,nsnon)=ii
   35 continue
   34 continue
   33 continue

!     Make the atom type list

      natt=0
      do 38 i=1,nsato
      do 39 ii=1,nparms
      do 40 j=1,i-1
      do 41 jj=1,nparms
      if(csato(ii+1,i).eq.csato(jj+1,j)) goto 39
   41 continue
   40 continue
      do 42 iii=1,ii-1
      if(csato(ii+1,i).eq.csato(iii+1,i)) goto 39
   42 continue
      natt=natt+1
      catt(1,natt)=csato(ii+1,i)//' '
   39 continue
   38 continue

!     Add atom type pointers to the atom list

      do 44 i=1,nsato
      do 45 j=1,natt
      if(catt(1,j)(1:5).eq.csato(2,i)) lsato(6,i)=j
      if(catt(1,j)(1:5).eq.csato(3,i)) lsato(7,i)=j
      if(catt(1,j)(1:5).eq.csato(4,i)) lsato(8,i)=j
   45 continue
   44 continue

!     Add atom pointers to the segment bonded lists

      do 46 i=1,nsgm

      do 47 j=1,lsndx(2,1,i)
      m=lsndx(2,2,i)-1+j
      lsbnd(5,m)=lsndx(1,2,i)-1+lsbnd(1,m)
      lsbnd(6,m)=lsndx(1,2,i)-1+lsbnd(2,m)
   47 continue

      do 48 j=1,lsndx(3,1,i)
      m=lsndx(3,2,i)-1+j
      lsang(6,m)=lsndx(1,2,i)-1+lsang(1,m)
      lsang(7,m)=lsndx(1,2,i)-1+lsang(2,m)
      lsang(8,m)=lsndx(1,2,i)-1+lsang(3,m)
   48 continue

      do 49 j=1,lsndx(4,1,i)
      m=lsndx(4,2,i)-1+j
      lsdih(10,m)=lsndx(1,2,i)-1+lsdih(1,m)
      lsdih(11,m)=lsndx(1,2,i)-1+lsdih(2,m)
      lsdih(12,m)=lsndx(1,2,i)-1+lsdih(3,m)
      lsdih(13,m)=lsndx(1,2,i)-1+lsdih(4,m)
   49 continue

      do 50 j=1,lsndx(5,1,i)
      m=lsndx(5,2,i)-1+j
      lsimp(10,m)=lsndx(1,2,i)-1+lsimp(1,m)
      lsimp(11,m)=lsndx(1,2,i)-1+lsimp(2,m)
      lsimp(12,m)=lsndx(1,2,i)-1+lsimp(3,m)
      lsimp(13,m)=lsndx(1,2,i)-1+lsimp(4,m)
   50 continue

   46 continue

!     Add atom pointers to the link bonded lists

      do 51 i=1,nsgl

      lsbnd(5,lsgl(4,i))=lsndx(1,2,lsgl(1,i))-1-lsbnd(1,lsgl(4,i))
      lsbnd(6,lsgl(4,i))=lsndx(1,2,lsgl(2,i))-1+lsbnd(2,lsgl(4,i))

      do 52 j=1,lsgl(5,i)
      lsang(6,lsgl(6,i)-1+j)=
     & lsndx(1,2,lsgl(1,i))-1-lsang(1,lsgl(6,i)-1+j)
      if(lsang(2,lsgl(6,i)-1+j).lt.0) then
      lsang(7,lsgl(6,i)-1+j)=
     & lsndx(1,2,lsgl(1,i))-1-lsang(2,lsgl(6,i)-1+j)
      else
      lsang(7,lsgl(6,i)-1+j)=
     & lsndx(1,2,lsgl(2,i))-1+lsang(2,lsgl(6,i)-1+j)
      endif
      lsang(8,lsgl(6,i)-1+j)=
     & lsndx(1,2,lsgl(2,i))-1+lsang(3,lsgl(6,i)-1+j)
   52 continue

      do 53 j=1,lsgl(7,i)
      lsdih(10,lsgl(8,i)-1+j)=
     & lsndx(1,2,lsgl(1,i))-1-lsdih(1,lsgl(8,i)-1+j)
      if(lsdih(2,lsgl(8,i)-1+j).lt.0) then
      lsdih(11,lsgl(8,i)-1+j)=
     & lsndx(1,2,lsgl(1,i))-1-lsdih(2,lsgl(8,i)-1+j)
      else
      lsdih(11,lsgl(8,i)-1+j)=
     & lsndx(1,2,lsgl(2,i))-1+lsdih(2,lsgl(8,i)-1+j)
      endif
      if(lsdih(3,lsgl(8,i)-1+j).lt.0) then
      lsdih(12,lsgl(8,i)-1+j)=
     & lsndx(1,2,lsgl(1,i))-1-lsdih(3,lsgl(8,i)-1+j)
      else
      lsdih(12,lsgl(8,i)-1+j)=
     & lsndx(1,2,lsgl(2,i))-1+lsdih(3,lsgl(8,i)-1+j)
      endif
      lsdih(13,lsgl(8,i)-1+j)=
     & lsndx(1,2,lsgl(2,i))-1+lsdih(4,lsgl(8,i)-1+j)
   53 continue

      do 54 j=1,lsgl(9,i)
      if(lsimp(1,lsgl(10,i)-1+j).lt.0) then
      lsimp(10,lsgl(10,i)-1+j)=
     & lsndx(1,2,lsgl(1,i))-1-lsimp(1,lsgl(10,i)-1+j)
      else
      lsimp(10,lsgl(10,i)-1+j)=
     & lsndx(1,2,lsgl(2,i))-1+lsimp(1,lsgl(10,i)-1+j)
      endif
      if(lsimp(2,lsgl(10,i)-1+j).lt.0) then
      lsimp(11,lsgl(10,i)-1+j)=
     & lsndx(1,2,lsgl(1,i))-1-lsimp(2,lsgl(10,i)-1+j)
      else
      lsimp(11,lsgl(10,i)-1+j)=
     & lsndx(1,2,lsgl(2,i))-1+lsimp(2,lsgl(10,i)-1+j)
      endif
      if(lsimp(3,lsgl(10,i)-1+j).lt.0) then
      lsimp(12,lsgl(10,i)-1+j)=
     & lsndx(1,2,lsgl(1,i))-1-lsimp(3,lsgl(10,i)-1+j)
      else
      lsimp(12,lsgl(10,i)-1+j)=
     & lsndx(1,2,lsgl(2,i))-1+lsimp(3,lsgl(10,i)-1+j)
      endif
      if(lsimp(4,lsgl(10,i)-1+j).lt.0) then
      lsimp(13,lsgl(10,i)-1+j)=
     & lsndx(1,2,lsgl(1,i))-1-lsimp(4,lsgl(10,i)-1+j)
      else
      lsimp(13,lsgl(10,i)-1+j)=
     & lsndx(1,2,lsgl(2,i))-1+lsimp(4,lsgl(10,i)-1+j)
      endif
   54 continue

   51 continue

      nsa=0
      do 55 i=1,nseq
      nsa=nsa+lsndx(1,1,lseq(5,i))
      write(lfnout,444) i,nseq,nsa
  444 format('NSA ',3i10)
   55 continue
      nwa=lsndx(1,1,lseq(5,nseq+1))

      return
      end

      subroutine prepare_parameters()

      use prepare_data

      implicit none

      integer i,j,jcomb,k,m,nt,ng,latnum,idir,ifil,ifnd,mult,nprms
      character*255 filnam
      character*80 card
      character*6 atyp1,atyp2,atyp3,atyp4,btyp1,btyp2,btyp3,btyp4
      character*1 qtm
      real*8 rmass,p1,p2,p3,p4,pt1,pt2,pt3,pt4,p1d(3),p2d(3)
      real*8 epsil,rstar

      integer mask(3),multd(3)

      nprms=3

      mask(1)=4
      mask(2)=2
      mask(3)=1

      releps=1.0d0
      q14fac=0.833333d0

      if(icomb.eq.0) icomb=3

      do 1 idir=1,mdirpar
      do 2 ifil=1,nfilpar(idir)
      write(filnam,'(a,a)') dirpar(idir)(1:index(dirpar(idir),' ')-1),
     & filpar(idir,ifil)(1:index(filpar(idir,ifil),' '))

      open(unit=lfnpar,file=filnam(1:index(filnam,' ')-1),
     & form='formatted',status='old',err=2)

    3 continue
      read(lfnpar,1000,end=999,err=9999) card
 1000 format(a)
      if(card(1:1).eq.'#') goto 3
      if(card(1:3).eq.'End') goto 2

    4 continue

!     1-4 electrostatic scaling

      if(card(1:32).eq.'Electrostatic 1-4 scaling factor') then
      read(card(34:45),'(f12.6)') q14fac
      goto 3
      endif

!     relative dielectric constant

      if(card(1:28).eq.'Relative dielectric constant') then
      read(card(30:41),'(f12.6)') releps
      goto 3
      endif

!     non-bonded parameter format

      if(card(1:17).eq.'Parameters C6 C12') then
      jcomb=1
      if(icomb.eq.2) write(lfnout,1102)
      if(icomb.eq.3) write(lfnout,1103)
 1101 format(/,' Parameters converted to C6 and C12')
 1102 format(/,' Parameters converted to epsilon and sigma')
 1103 format(/,' Parameters converted to epsilon and R*')
      goto 3
      endif

      if(card(1:24).eq.'Parameters epsilon sigma') then
      jcomb=2
      if(icomb.eq.1) write(lfnout,1101)
      if(icomb.eq.3) write(lfnout,1103)
      goto 3
      endif

      if(card(1:21).eq.'Parameters epsilon R*') then
      jcomb=3
      if(icomb.eq.1) write(lfnout,1101)
      if(icomb.eq.2) write(lfnout,1102)
      goto 3
      endif

!     atom types

      if(card(1:5).eq.'Atoms') then
      atyp1(6:6)=' '
      atyp2(6:6)=' '
    5 continue
      read(lfnpar,1000,end=999) card
      if(card(1:1).eq.'#') goto 5
      if(card(1:5).eq.'Cross') goto 4
      if(card(1:5).eq.'Bonds') goto 4
      if(card(1:6).eq.'Angles') goto 4
      if(card(1:16).eq.'Proper dihedrals') goto 4
      if(card(1:18).eq.'Improper dihedrals') goto 4
      if(card(1:10).eq.'Atom types') goto 4
      if(card(1:3).eq.'End') goto 2
      read(card,1001,err=2) atyp1(1:5),rmass,p1,p2,p3,p4,nt,ng
 1001 format(a5,f10.5,4e12.5,i5,1x,i10)
      if(atyp1.eq.'      ') goto 3
      read(lfnpar,1002,err=9999) atyp2(1:5),qtm,latnum,pt1,pt2,pt3,pt4
 1002 format(a5,1x,a1,3x,i5,4e12.5)
      if(atyp2.eq.'      ') atyp2=atyp1
      do 6 i=1,natt
      if(catt(1,i)(1:5).eq.atyp1(1:5).and.
     & (qtm.eq.' '.or.qtm.eq.catt(1,i)(6:6))) then
      catt(2,i)=atyp2
      ratt(i)=rmass
      latt(1,i)=latnum
      latt(2,i)=nt
      latt(3,i)=ng

      if(icomb.ne.jcomb) then
      if(icomb.eq.1) then
      if(jcomb.eq.2) then
      stop 'Parameter conversion not implemented'
      elseif(jcomb.eq.3) then
      stop 'Parameter conversion not implemented'
      elseif(jcomb.eq.4) then
      stop 'Parameter conversion not implemented'
      endif
      elseif(icomb.eq.2) then
      if(jcomb.eq.1) then
      stop 'Parameter conversion not implemented'
      elseif(jcomb.eq.3) then
      stop 'Parameter conversion not implemented'
      elseif(jcomb.eq.4) then
      stop 'Parameter conversion not implemented'
      endif
      elseif(icomb.eq.3) then
      if(jcomb.eq.1) then
      patt(1,1,i,i)=0.25d0*(p1*p1/p2)
      patt(2,1,i,i)=0.5d0*((2.0d0*p2/p1)**(1.0d0/6.0d0))
      patt(3,1,i,i)=p3
      patt(4,1,i,i)=p4
      patt(1,2,i,i)=0.25d0*(pt1*pt1/pt2)
      patt(2,2,i,i)=0.5d0*((2.0d0*pt2/pt1)**(1.0d0/6.0d0))
      patt(3,2,i,i)=pt3
      patt(4,2,i,i)=pt4
      elseif(jcomb.eq.2) then
      stop 'Parameter conversion not implemented'
      elseif(jcomb.eq.4) then
      stop 'Parameter conversion not implemented'
      endif
      elseif(icomb.eq.4) then
      if(jcomb.eq.1) then
      stop 'Parameter conversion not implemented'
      elseif(jcomb.eq.2) then
      stop 'Parameter conversion not implemented'
      elseif(jcomb.eq.3) then
      stop 'Parameter conversion not implemented'
      endif
      endif
      else
      patt(1,1,i,i)=p1
      patt(2,1,i,i)=p2
      patt(3,1,i,i)=p3
      patt(4,1,i,i)=p4
      patt(1,2,i,i)=pt1
      patt(2,2,i,i)=pt2
      patt(3,2,i,i)=pt3
      patt(4,2,i,i)=pt4
      endif

      do 7 j=1,natt
      if(i.ne.j) then
      if(icomb.eq.1) then
      endif
      if(icomb.eq.2) then
      patt(1,1,i,j)=sqrt(patt(1,1,i,i)*patt(1,1,j,j))
      patt(1,1,j,i)=patt(1,1,i,j)
      patt(2,1,i,j)=patt(2,1,i,i)+patt(2,1,j,j)
      patt(2,1,j,i)=patt(2,1,i,j)
      patt(1,2,i,j)=sqrt(patt(1,2,i,i)*patt(1,2,j,j))
      patt(1,2,j,i)=patt(1,2,i,j)
      patt(2,2,i,j)=patt(2,2,i,i)+patt(2,2,j,j)
      patt(2,2,j,i)=patt(2,2,i,j)
      endif
      if(icomb.eq.3) then
      patt(1,1,i,j)=sqrt(patt(1,1,i,i)*patt(1,1,j,j))
      patt(1,1,j,i)=patt(1,1,i,j)
      patt(2,1,i,j)=patt(2,1,i,i)+patt(2,1,j,j)
      patt(2,1,j,i)=patt(2,1,i,j)
      patt(1,2,i,j)=sqrt(patt(1,2,i,i)*patt(1,2,j,j))
      patt(1,2,j,i)=patt(1,2,i,j)
      patt(2,2,i,j)=patt(2,2,i,i)+patt(2,2,j,j)
      patt(2,2,j,i)=patt(2,2,i,j)
      endif
      endif
    7 continue
      endif
    6 continue
      goto 5
      endif

!     cross terms

      if(card(1:5).eq.'Cross') then
      atyp1(6:6)=' '
      atyp2(6:6)=' '
    8 continue
      read(lfnpar,1000,end=999) card
      if(card(1:1).eq.'#') goto 8
      if(card(1:5).eq.'Atoms') goto 4
      if(card(1:5).eq.'Bonds') goto 4
      if(card(1:6).eq.'Angles') goto 4
      if(card(1:16).eq.'Proper dihedrals') goto 4
      if(card(1:18).eq.'Improper dihedrals') goto 4
      if(card(1:10).eq.'Atom types') goto 4
      if(card(1:3).eq.'End') goto 2
      read(card,1003,err=2) atyp1(1:5),atyp2(1:5),p1,p2
 1003 format(a5,1x,a5,2x,2e12.5)
      if(atyp1.eq.'      ') goto 3
      if(atyp2.eq.'      ') goto 3
      read(lfnpar,1004,err=9999) pt1,pt2
 1004 format(13x,2e12.5)

      do 9 i=1,natt
      if(catt(1,i)(1:5).eq.atyp1) then
      do 10 j=1,natt
      if(catt(1,i)(1:5).eq.atyp2) then

      if(icomb.ne.jcomb) then
      if(icomb.eq.1) then
      if(jcomb.eq.2) then
      stop 'Parameter conversion not implemented'
      elseif(jcomb.eq.3) then
      stop 'Parameter conversion not implemented'
      elseif(jcomb.eq.4) then
      stop 'Parameter conversion not implemented'
      endif
      elseif(icomb.eq.2) then
      if(jcomb.eq.1) then
      stop 'Parameter conversion not implemented'
      elseif(jcomb.eq.3) then
      stop 'Parameter conversion not implemented'
      elseif(jcomb.eq.4) then
      stop 'Parameter conversion not implemented'
      endif
      elseif(icomb.eq.3) then
      if(jcomb.eq.1) then
      patt(1,1,i,j)=0.25d0*(p1*p1/p2)
      patt(2,1,i,j)=0.5d0*((2.0d0*p2/p1)**(1.0d0/6.0d0))
      patt(3,1,i,j)=p3
      patt(4,1,i,j)=p4
      patt(1,2,i,j)=0.25d0*(pt1*pt1/pt2)
      patt(2,2,i,j)=0.5d0*((2.0d0*pt2/pt1)**(1.0d0/6.0d0))
      patt(3,2,i,j)=pt3
      patt(4,2,i,j)=pt4
      elseif(jcomb.eq.2) then
      stop 'Parameter conversion not implemented'
      elseif(jcomb.eq.4) then
      stop 'Parameter conversion not implemented'
      endif
      elseif(icomb.eq.4) then
      if(jcomb.eq.1) then
      stop 'Parameter conversion not implemented'
      elseif(jcomb.eq.2) then
      stop 'Parameter conversion not implemented'
      elseif(jcomb.eq.3) then
      stop 'Parameter conversion not implemented'
      endif
      endif
      else
      if(icomb.eq.1) then
      patt(1,1,i,j)=p1
      patt(2,1,i,j)=p2
      patt(3,1,i,j)=p3
      patt(4,1,i,j)=p4
      patt(1,2,i,j)=pt1
      patt(2,2,i,j)=pt2
      patt(3,2,i,j)=pt3
      patt(4,2,i,j)=pt4
      elseif(icomb.eq.2) then
      patt(1,1,i,j)=p1
      patt(2,1,i,j)=p2+p2
      patt(3,1,i,j)=p3
      patt(4,1,i,j)=p4
      patt(1,2,i,j)=pt1
      patt(2,2,i,j)=pt2+pt2
      patt(3,2,i,j)=pt3
      patt(4,2,i,j)=pt4
      elseif(icomb.eq.3) then
      patt(1,1,i,j)=p1
      patt(2,1,i,j)=p2+p2
      patt(3,1,i,j)=p3
      patt(4,1,i,j)=p4
      patt(1,2,i,j)=pt1
      patt(2,2,i,j)=pt2+pt2
      patt(3,2,i,j)=pt3
      patt(4,2,i,j)=pt4
      elseif(icomb.eq.4) then
      patt(1,1,i,j)=p1
      patt(2,1,i,j)=p2
      patt(3,1,i,j)=p3
      patt(4,1,i,j)=p4
      patt(1,2,i,j)=pt1
      patt(2,2,i,j)=pt2
      patt(3,2,i,j)=pt3
      patt(4,2,i,j)=pt4
      endif
      endif

!      if(icomb.eq.1) then
!      patt(1,1,i,j)=p1
!      patt(2,1,i,j)=p2
!      patt(1,2,i,j)=pt1
!      patt(2,2,i,j)=pt2
!      endif
!      if(icomb.eq.2) then
!      endif
!      if(icomb.eq.3) then
!      patt(1,1,i,j)=sqrt(p1*p1)
!      patt(2,1,i,j)=p2+p2
!      patt(1,2,i,j)=sqrt(pt1*pt1)
!      patt(2,2,i,j)=pt2+pt2
!      endif

      patt(1,1,j,i)=patt(1,1,i,j)
      patt(2,1,j,i)=patt(2,1,i,j)
      patt(1,2,j,i)=patt(1,2,i,j)
      patt(2,2,j,i)=patt(2,2,i,j)
      endif
   10 continue
      endif
    9 continue
      goto 8
      endif

!     bonds

      if(card(1:5).eq.'Bonds') then
      atyp1(6:6)=' '
      atyp2(6:6)=' '
      btyp1(6:6)=' '
      btyp2(6:6)=' '
   11 continue
      read(lfnpar,1000,end=999) card
      if(card(1:1).eq.'#') goto 11
      if(card(1:5).eq.'Atoms') goto 4
      if(card(1:5).eq.'Cross') goto 4
      if(card(1:6).eq.'Angles') goto 4
      if(card(1:16).eq.'Proper dihedrals') goto 4
      if(card(1:18).eq.'Improper dihedrals') goto 4
      if(card(1:10).eq.'Atom types') goto 4
      if(card(1:3).eq.'End') goto 2
      read(card,1005,err=2) atyp1(1:5),atyp2(1:5),p1,p2
 1005 format(a5,1x,a5,f10.5,e12.5)
      if(atyp1.eq.'      ') goto 3
      if(atyp2.eq.'      ') goto 3
      do 12 i=1,nsbnd
      do 13 j=1,nprms
      btyp1(1:5)=catt(1,lsato(5+j,lsbnd(5,i)))(1:5)
      btyp2(1:5)=catt(1,lsato(5+j,lsbnd(6,i)))(1:5)
      if((atyp1.eq.btyp1.and.atyp2.eq.btyp2).or.
     & (atyp2.eq.btyp1.and.atyp1.eq.btyp2)) then
      sbnd(1,i,j)=p1
      sbnd(2,i,j)=p2
      if(latt(1,lsato(5+j,lsbnd(5,i))).eq.1) lsbnd(3,i)=1
      if(latt(1,lsato(5+j,lsbnd(6,i))).eq.1) lsbnd(3,i)=1 
      lsbnd(4,i)=-(ior(iabs(lsbnd(4,i)),2**(j-1)))
      endif
   13 continue
   12 continue
      goto 11
      endif

!     angles

      if(card(1:6).eq.'Angles') then
      atyp1(6:6)=' '
      atyp2(6:6)=' '
      atyp3(6:6)=' '
      btyp1(6:6)=' '
      btyp2(6:6)=' '
      btyp3(6:6)=' '
   14 continue
      read(lfnpar,1000,end=999) card
      if(card(1:1).eq.'#') goto 14
      if(card(1:5).eq.'Atoms') goto 4
      if(card(1:5).eq.'Cross') goto 4
      if(card(1:5).eq.'Bonds') goto 4
      if(card(1:16).eq.'Proper dihedrals') goto 4
      if(card(1:18).eq.'Improper dihedrals') goto 4
      if(card(1:10).eq.'Atom types') goto 4
      if(card(1:3).eq.'End') goto 2
      if(ffield(1:6).ne.'charmm') then
      read(card,1006,err=2) atyp1(1:5),atyp2(1:5),atyp3(1:5),p1,p2
      else
      read(card,1006,err=2) atyp1(1:5),atyp2(1:5),atyp3(1:5),p1,p2,p3,p4
      endif
 1006 format(a5,1x,a5,1x,a5,2(f10.5,e12.5))
      if(atyp1.eq.'      ') goto 3
      if(atyp2.eq.'      ') goto 3
      if(atyp3.eq.'      ') goto 3
      do 15 i=1,nsang
      if(lsang(4,i).le.0) then
      do 16 j=1,nprms
      if(iand(mask(j),lsang(5,i)).eq.0) then
      btyp1(1:5)=catt(1,lsato(5+j,lsang(6,i)))(1:5)
      btyp2(1:5)=catt(1,lsato(5+j,lsang(7,i)))(1:5)
      btyp3(1:5)=catt(1,lsato(5+j,lsang(8,i)))(1:5)
      if(atyp2.eq.btyp2.and.((atyp1.eq.btyp1.and.atyp3.eq.btyp3).or.
     & (atyp3.eq.btyp1.and.atyp1.eq.btyp3))) then
      sang(1,i,j)=p1
      sang(2,i,j)=p2
      if(ffield(1:6).eq.'charmm') then
      sang(1,i,j)=p3
      sang(2,i,j)=p4
      endif
      lsang(4,i)=-(ior(iabs(lsang(4,i)),2**(j-1)))
      endif
      endif
   16 continue
      endif
   15 continue
      goto 14
      endif

!     torsions

      if(card(1:16).eq.'Proper dihedrals') then
      atyp1(6:6)=' '
      atyp2(6:6)=' '
      atyp3(6:6)=' '
      atyp4(6:6)=' '
      btyp1(6:6)=' '
      btyp2(6:6)=' '
      btyp3(6:6)=' '
      btyp4(6:6)=' '
   17 continue
      read(lfnpar,1000,end=999) card
      if(card(1:1).eq.'#') goto 17
      if(card(1:5).eq.'Atoms') goto 4
      if(card(1:5).eq.'Cross') goto 4
      if(card(1:5).eq.'Bonds') goto 4
      if(card(1:6).eq.'Angles') goto 4
      if(card(1:18).eq.'Improper dihedrals') goto 4
      if(card(1:10).eq.'Atom types') goto 4
      if(card(1:3).eq.'End') goto 2
      read(card,1007,err=2) atyp1(1:5),atyp2(1:5),atyp3(1:5),atyp4(1:5),
     & p1d(1),p2d(1),multd(1)
      if(multd(1).lt.0) then
      read(lfnpar,1000,end=999) card
      read(card,1007,err=2) atyp1(1:5),atyp2(1:5),atyp3(1:5),atyp4(1:5),
     & p1d(2),p2d(2),multd(2)
      if(multd(2).lt.0) then
      read(lfnpar,1000,end=999) card
      read(card,1007,err=2) atyp1(1:5),atyp2(1:5),atyp3(1:5),atyp4(1:5),
     & p1d(3),p2d(3),multd(3)
      if(multd(3).lt.0) stop 'Too many duplicates in dihedral'
      endif
      endif
 1007 format(a5,1x,a5,1x,a5,1x,a5,f10.5,e12.5,i5)
      if(atyp2.eq.'      ') goto 3
      if(atyp3.eq.'      ') goto 3
      do 18 i=1,nsdih
      if(lsdih(5,i).le.0) then
      do 19 j=1,nprms
      if(iand(mask(j),lsdih(6,i)).eq.0) then

      btyp1(1:5)=catt(1,lsato(5+j,lsdih(10,i)))(1:5)
      btyp2(1:5)=catt(1,lsato(5+j,lsdih(11,i)))(1:5)
      btyp3(1:5)=catt(1,lsato(5+j,lsdih(12,i)))(1:5)
      btyp4(1:5)=catt(1,lsato(5+j,lsdih(13,i)))(1:5)

      if(((atyp1.eq.'      '.or.atyp1.eq.btyp1).and.
     & atyp2.eq.btyp2.and.atyp3.eq.btyp3.and.
     & (atyp4.eq.'      '.or.atyp4.eq.btyp4)).or.
     & ((atyp1.eq.'      '.or.atyp1.eq.btyp4).and.
     & atyp2.eq.btyp3.and.atyp3.eq.btyp2.and.
     & (atyp4.eq.'      '.or.atyp4.eq.btyp1))) then
      lsdih(6+j,i)=multd(1)
      sdih(1,i,j,1)=p1d(1) 
      sdih(2,i,j,1)=p2d(1)
      if(multd(1).lt.0) then
      lsdih(13+j,i)=multd(2)
      sdih(1,i,j,2)=p1d(2) 
      sdih(2,i,j,2)=p2d(2)
      if(multd(2).lt.0) then
      lsdih(15+j,i)=multd(3)
      sdih(1,i,j,3)=p1d(3) 
      sdih(2,i,j,3)=p2d(3)
      endif
      endif
      lsdih(5,i)=-(ior(iabs(lsdih(5,i)),2**(j-1)))
      endif

      endif
   19 continue
      endif
   18 continue
      goto 17
      endif

!     impropers

      if(card(1:18).eq.'Improper dihedrals') then
      atyp1(6:6)=' '
      atyp2(6:6)=' '
      atyp3(6:6)=' '
      atyp4(6:6)=' '
      btyp1(6:6)=' '
      btyp2(6:6)=' '
      btyp3(6:6)=' '
      btyp4(6:6)=' '
   20 continue
      read(lfnpar,1000,end=999) card
      if(card(1:1).eq.'#') goto 20
      if(card(1:5).eq.'Atoms') goto 4
      if(card(1:5).eq.'Cross') goto 4
      if(card(1:5).eq.'Bonds') goto 4
      if(card(1:6).eq.'Angles') goto 4
      if(card(1:16).eq.'Proper dihedrals') goto 4
      if(card(1:10).eq.'Atom types') goto 4
      if(card(1:3).eq.'End') goto 2
      if(ffield(1:5).eq.'amber') then
      read(card,1008,err=2) atyp1(1:5),atyp2(1:5),atyp3(1:5),atyp4(1:5),
     & p1,p2,mult
 1008 format(a5,1x,a5,1x,a5,1x,a5,f10.5,e12.5,i5)
      else
      read(card,1008,err=2) atyp1(1:5),atyp2(1:5),atyp3(1:5),atyp4(1:5),
     & p1,p2,mult
      endif
      if(atyp3.eq.'      ') goto 3
      if(atyp4.eq.'      ') goto 3
      do 21 i=1,nsimp
      if(lsimp(5,i).le.0) then
      do 22 j=1,nprms
      if(iand(mask(j),lsimp(6,i)).eq.0) then

      btyp1(1:5)=catt(1,lsato(5+j,lsimp(10,i)))(1:5)
      btyp2(1:5)=catt(1,lsato(5+j,lsimp(11,i)))(1:5)
      btyp3(1:5)=catt(1,lsato(5+j,lsimp(12,i)))(1:5)
      btyp4(1:5)=catt(1,lsato(5+j,lsimp(13,i)))(1:5)

      ifnd=0
      if(atyp3.eq.btyp3) then
      if(atyp1.eq.'      ') then
      if(atyp2.eq.'      ') then
      if(atyp4.eq.btyp4) ifnd=1
      if(atyp4.eq.btyp2) ifnd=1
      if(atyp4.eq.btyp1) ifnd=1
      else
      if(atyp2.eq.btyp2.and.atyp4.eq.btyp4) ifnd=1
      if(atyp2.eq.btyp4.and.atyp4.eq.btyp2) ifnd=1
      if(atyp2.eq.btyp1.and.atyp4.eq.btyp4) ifnd=1
      if(atyp2.eq.btyp4.and.atyp4.eq.btyp1) ifnd=1
      if(atyp2.eq.btyp1.and.atyp4.eq.btyp2) ifnd=1
      if(atyp2.eq.btyp2.and.atyp4.eq.btyp1) ifnd=1
      endif
      else
      if(atyp2.eq.'      ') then
      if(atyp1.eq.btyp2.and.atyp4.eq.btyp4) ifnd=1
      if(atyp1.eq.btyp4.and.atyp4.eq.btyp2) ifnd=1
      if(atyp1.eq.btyp1.and.atyp4.eq.btyp4) ifnd=1
      if(atyp1.eq.btyp4.and.atyp4.eq.btyp1) ifnd=1
      if(atyp1.eq.btyp1.and.atyp4.eq.btyp2) ifnd=1
      if(atyp1.eq.btyp2.and.atyp4.eq.btyp1) ifnd=1
      else
      if(atyp1.eq.btyp1.and.atyp2.eq.btyp2.and.atyp4.eq.btyp4) ifnd=1
      if(atyp1.eq.btyp2.and.atyp2.eq.btyp4.and.atyp4.eq.btyp1) ifnd=1
      if(atyp1.eq.btyp4.and.atyp2.eq.btyp1.and.atyp4.eq.btyp2) ifnd=1
      if(atyp1.eq.btyp2.and.atyp2.eq.btyp1.and.atyp4.eq.btyp4) ifnd=-1
      if(atyp1.eq.btyp1.and.atyp2.eq.btyp4.and.atyp4.eq.btyp2) ifnd=-1
      if(atyp1.eq.btyp4.and.atyp2.eq.btyp2.and.atyp4.eq.btyp1) ifnd=-1
      endif
      endif
      endif

      if(ffield(1:5).eq.'charm'.and.ifnd.eq.0) then
      if(atyp4.eq.btyp3) then
      if(atyp2.eq.'      ') then
      if(atyp1.eq.'      ') then
      if(atyp3.eq.btyp4) ifnd=1
      if(atyp3.eq.btyp2) ifnd=1
      if(atyp3.eq.btyp1) ifnd=1
      else
      if(atyp1.eq.btyp2.and.atyp3.eq.btyp4) ifnd=1
      if(atyp1.eq.btyp4.and.atyp3.eq.btyp2) ifnd=1
      if(atyp1.eq.btyp1.and.atyp3.eq.btyp4) ifnd=1
      if(atyp1.eq.btyp4.and.atyp3.eq.btyp1) ifnd=1
      if(atyp1.eq.btyp1.and.atyp3.eq.btyp2) ifnd=1
      if(atyp1.eq.btyp2.and.atyp3.eq.btyp1) ifnd=1
      endif
      else
      if(atyp1.eq.'      ') then
      if(atyp2.eq.btyp2.and.atyp3.eq.btyp4) ifnd=1
      if(atyp2.eq.btyp4.and.atyp3.eq.btyp2) ifnd=1
      if(atyp2.eq.btyp1.and.atyp3.eq.btyp4) ifnd=1
      if(atyp2.eq.btyp4.and.atyp3.eq.btyp1) ifnd=1
      if(atyp2.eq.btyp1.and.atyp3.eq.btyp2) ifnd=1
      if(atyp2.eq.btyp2.and.atyp3.eq.btyp1) ifnd=1
      else
      if(atyp2.eq.btyp1.and.atyp1.eq.btyp2.and.atyp3.eq.btyp4) ifnd=1
      if(atyp2.eq.btyp2.and.atyp1.eq.btyp4.and.atyp3.eq.btyp1) ifnd=1
      if(atyp2.eq.btyp4.and.atyp1.eq.btyp1.and.atyp3.eq.btyp2) ifnd=1
      if(atyp2.eq.btyp2.and.atyp1.eq.btyp1.and.atyp3.eq.btyp4) ifnd=-1
      if(atyp2.eq.btyp1.and.atyp1.eq.btyp4.and.atyp3.eq.btyp2) ifnd=-1
      if(atyp2.eq.btyp4.and.atyp1.eq.btyp2.and.atyp3.eq.btyp1) ifnd=-1
      endif
      endif
      endif
      endif

      if(ifnd.ne.0) then
      lsimp(6+j,i)=mult
      simp(1,i,j)=ifnd*p1 
      simp(2,i,j)=p2 
      lsimp(5,i)=-(ior(iabs(lsimp(5,i)),2**(j-1)))
      endif
      endif

   22 continue
      endif
   21 continue
      goto 20
      endif

      goto 3

  999 continue

      close(unit=lfnpar)
    2 continue
    1 continue

!     Convert the non-bonded parameters to C12 and C6 as used in ARGOS
!     C6,C12 -> C6,C12

      if(icomb.eq.1) then
      endif

!     epsilon,sigma  -> C6,C12

      if(icomb.eq.2) then
      endif

!     epsilon,(1/2)R* -> C6,C12

      if(icomb.eq.3) then
      do 23 i=1,natt
      do 24 k=1,2
      epsil=patt(1,k,i,i)
      rstar=patt(2,k,i,i)
      patt(1,k,i,i)=2.0d0*epsil*((rstar+rstar)**6)
      patt(2,k,i,i)=epsil*((rstar+rstar)**12)
   24 continue
      do 25 j=i+1,natt
      if(i.ne.j) then
      do 26 k=1,2
      epsil=patt(1,k,i,j)
      rstar=patt(2,k,i,j)
      patt(1,k,i,j)=2.0d0*epsil*((rstar)**6)
      patt(1,k,j,i)=patt(1,k,i,j)
      patt(2,k,i,j)=epsil*((rstar)**12)
      patt(2,k,j,i)=patt(2,k,i,j)
   26 continue
      endif
   25 continue
   23 continue
      endif

!     modify parameters for self and dummy

      do 27 i=1,natt
      do 28 j=i,natt
      if((catt(1,i)(6:6).eq.'S'.and.catt(1,j)(6:6).ne.'S').or.
     & (catt(1,i)(6:6).ne.'S'.and.catt(1,j)(6:6).eq.'S')) then
      patt(1,1,i,j)=0.0d0
      patt(1,2,i,j)=0.0d0
      patt(2,1,i,j)=0.0d0
      patt(2,2,i,j)=0.0d0
      patt(1,1,j,i)=0.0d0
      patt(1,2,j,i)=0.0d0
      patt(2,1,j,i)=0.0d0
      patt(2,2,j,i)=0.0d0
      endif
   28 continue
      if(catt(1,i)(6:6).eq.'D') then
      patt(1,1,i,i)=0.0d0
      patt(1,2,i,i)=0.0d0
      patt(2,1,i,i)=0.0d0
      patt(2,2,i,i)=0.0d0
      do 29 j=1,natt
      patt(1,1,i,j)=0.0d0
      patt(1,2,i,j)=0.0d0
      patt(2,1,i,j)=0.0d0
      patt(2,2,i,j)=0.0d0
      patt(1,1,j,i)=0.0d0
      patt(1,2,j,i)=0.0d0
      patt(2,1,j,i)=0.0d0
      patt(2,2,j,i)=0.0d0
   29 continue
      endif
      if(catt(1,i)(6:6).eq.'Q'.or.catt(1,i)(6:6).eq.'H') then
      patt(1,1,i,i)=0.0d0
      patt(1,2,i,i)=0.0d0
      patt(2,1,i,i)=0.0d0
      patt(2,2,i,i)=0.0d0
      do 30 j=1,natt
      if(catt(1,j)(6:6).eq.'Q'.or.catt(1,j)(6:6).eq.'H') then
      patt(1,1,i,j)=0.0d0
      patt(1,2,i,j)=0.0d0
      patt(2,1,i,j)=0.0d0
      patt(2,2,i,j)=0.0d0
      patt(1,1,j,i)=0.0d0
      patt(1,2,j,i)=0.0d0
      patt(2,1,j,i)=0.0d0
      patt(2,2,j,i)=0.0d0
      endif
   30 continue
      endif
   27 continue

      return

 9999 stop 'Error reading parameter file'

      return
      end

      subroutine prepare_write_topology()

      use prepare_data

      implicit none

      integer i,j,k,m,non

      call swatch(dattop,timtop)

      open(unit=lfntop,file=filtop(1:index(filtop,' ')-1),
     & form='formatted',status='unknown')

      call swatch(date,time)
      write(lfntop,1000) (title(1,i),i=1,3),
     & dattop,timtop,ffield,version,user,nparms,releps,q14fac,nsa,nwa,
     & natt,nsgm,nsgl,nseq,nato,nmol,nslv,
     & nlnk,nsato,nsbnd,nsang,nsdih,nsimp,nsnon,nunon
 1000 format(a,/,a,/,a,/,3a10,f12.6,1x,a,/,i3,2f12.6,i10,i5,/,
     & 7i10,/,8i10)

!     Atom types

      do 1 i=1,natt
      write(lfntop,1002) i,latt(1,i),catt(1,i),ratt(i)
 1002 format(2i5,1x,a6,f12.6)
    1 continue

!     Van der Waals parameters

      do 2 i=1,natt
      do 3 j=i,natt
      write(lfntop,1003) i,j,((patt(m,k,i,j),k=1,2),m=1,2)
 1003 format(2i5,4(1pe12.5))
    3 continue
    2 continue

!     Unique segments

      do 4 i=1,nsgm
      write(lfntop,1004) i,csgm(1,i),((lsndx(k,j,i),j=1,2),k=1,6)
 1004 format(i5,2x,a5,3(i5,i10),/,12x,3(i5,i10))
    4 continue

!     Unique segment links

      do 5 i=1,nsgl
      write(lfntop,1005) i,lsgl(1,i),lsgl(2,i),1,(lsgl(j,i),j=4,12)
 1005 format(3i5,3(i5,i10),/,15x,2(i5,i10))
    5 continue

!     Solute sequence: segment number and segment pointers

      if(nseq.gt.0) then
      write(lfntop,1006) (lseq(1,i),i=1,nseq)
      write(lfntop,1006) (lseq(4,i),i=1,nseq)
      write(lfntop,1006) (lseq(5,i),i=1,nseq)
 1006 format(10i8)
      endif

!     Solute links

      if(nlnk.gt.0) then
      write(lfntop,1007) (llnk(1,i),i=1,nlnk)
      write(lfntop,1007) (llnk(2,i),i=1,nlnk)
      write(lfntop,1007) (llnk(3,i),i=1,nlnk)
 1007 format(10i8)
      endif

!     Solvents

      do 8 i=1,nslv
      write(lfntop,1008) lseq(1,nseq+i),lseq(5,nseq+i)
 1008 format(2i8)
    8 continue

!     Atom list

      do 9 i=1,nsato
      write(lfntop,1009) i,csato(1,i),(lsato(j,i),j=4,8),
     & ((sato(j,i,m),j=1,2),m=1,3)
 1009 format(i5,1x,a5,5i4,6f9.6)
    9 continue

!      Bond list

      do 10 i=1,nsbnd
      write(lfntop,1010) i,(lsbnd(j,i),j=1,3),
     & ((sbnd(k,i,m),k=1,2),m=1,3)
 1010 format(4i5,3(f8.5,e12.5))
   10 continue

!     Angle list

      do 11 i=1,nsang
      write(lfntop,1011) i,(lsang(j,i),j=1,3),
     & ((sang(k,i,m),k=1,2),m=1,3)
 1011 format(4i5,3(f8.5,e12.5))
   11 continue

!     Torsion list

      do 12 i=1,nsdih
      write(lfntop,1012) i,(lsdih(j,i),j=1,4),
     & (lsdih(6+m,i),(sdih(k,i,m,1),k=1,2),m=1,3)
 1012 format(5i5,3(i3,f8.5,e12.5))
      if(lsdih(7,i).lt.0.or.lsdih(8,i).lt.0.or.lsdih(9,i).lt.0) then
      write(lfntop,1112)
     & (lsdih(13+m,i),(sdih(k,i,m,2),k=1,2),m=1,3)
 1112 format(25x,3(i3,f8.5,e12.5))
      if(lsdih(14,i).lt.0.or.lsdih(15,i).lt.0.or.lsdih(16,i).lt.0) then
      write(lfntop,1112)
     & (lsdih(16+m,i),(sdih(k,i,m,3),k=1,2),m=1,3)
      endif
      endif
   12 continue

!     Improper list

      do 13 i=1,nsimp
      write(lfntop,1013) i,(lsimp(j,i),j=1,4),
     & (lsimp(6+m,i),(simp(k,i,m),k=1,2),m=1,3)
 1013 format(5i5,3(i3,f8.5,e12.5))
   13 continue

!     Non-bonded list

      if(nsnon.gt.0) then
      write(lfntop,1014) (lsnon(1,i),i=1,nsnon)
      write(lfntop,1014) (lsnon(2,i),i=1,nsnon)
      write(lfntop,1014) (lsnon(3,i),i=1,nsnon)
 1014 format(10i8)
      endif

      close(unit=lfntop)

      write(lfnout,1000) (title(1,i),i=1,3),date,time,ffield,version,
     & natt,nsgm,nseq,nslv,nsato,nsbnd,nsang,nsdih,nsimp,nsnon

      do 110 i=1,nseq
      write(lfnout,2002) i,(lseq(j,i),j=1,6),cseq(1,i)
 2002 format(7i5,2(1x,a5))
  110 continue

      do 111 i=1,nsgm
      write(lfnout,2003) i,csgm(1,i),(lsndx(k,1,i),k=1,6)
 2003 format(i5,1x,a5,1x,7i5)

      do 112 j=1,lsndx(1,1,i)
      write(lfnout,2004) (lsato(k,lsndx(1,2,i)-1+j),k=1,8),
     & (csato(k,lsndx(1,2,i)-1+j),k=1,4),
     & ((sato(k,lsndx(1,2,i)-1+j,m),k=1,2),m=1,3)
 2004 format(8i5,4(1x,a5),6f8.5)
  112 continue
      do 113 j=1,lsndx(2,1,i)
      write(lfnout,2005) (lsbnd(k,lsndx(2,2,i)-1+j),k=1,6),
     & ((sbnd(k,lsndx(2,2,i)-1+j,m),k=1,2),m=1,3)
 2005 format(6i5,3(f8.5,e12.5))
  113 continue
      do 114 j=1,lsndx(3,1,i)
      write(lfnout,2006) (lsang(k,lsndx(3,2,i)-1+j),k=1,8),
     & ((sang(k,lsndx(3,2,i)-1+j,m),k=1,2),m=1,3)
 2006 format(8i5,3(f8.5,e12.5))
  114 continue
      do 115 j=1,lsndx(4,1,i)
      write(lfnout,2007) (lsdih(k,lsndx(4,2,i)-1+j),k=1,6),
     & (lsdih(k,lsndx(4,2,i)-1+j),k=10,13),
     & (lsdih(6+m,lsndx(4,2,i)-1+j),
     & (sdih(k,lsndx(4,2,i)-1+j,m,1),k=1,2),m=1,3)
 2007 format(10i5,3(i3,f8.5,e12.5))
      if(lsdih(7,lsndx(4,2,i)-1+j).lt.0) then
      write(lfnout,2007) (lsdih(k,lsndx(4,2,i)-1+j),k=1,6),
     & (lsdih(k,lsndx(4,2,i)-1+j),k=10,13),
     & (lsdih(13+m,lsndx(4,2,i)-1+j),
     & (sdih(k,lsndx(4,2,i)-1+j,m,2),k=1,2),m=1,3)
      endif
      if(lsdih(14,lsndx(4,2,i)-1+j).lt.0) then
      write(lfnout,2007) (lsdih(k,lsndx(4,2,i)-1+j),k=1,6),
     & (lsdih(k,lsndx(4,2,i)-1+j),k=10,13),
     & (lsdih(16+m,lsndx(4,2,i)-1+j),
     & (sdih(k,lsndx(4,2,i)-1+j,m,3),k=1,2),m=1,3)
      endif
  115 continue
      do 117 j=1,lsndx(5,1,i)
      write(lfnout,2008) (lsimp(k,lsndx(5,2,i)-1+j),k=1,6),
     & (lsimp(k,lsndx(5,2,i)-1+j),k=10,13),
     & (lsimp(6+m,lsndx(5,2,i)-1+j),
     & (simp(k,lsndx(5,2,i)-1+j,m),k=1,2),m=1,3)
 2008 format(10i5,3(i3,f8.5,e12.5))
  117 continue
      do 118 j=1,lsndx(6,1,i)
      write(lfnout,2009) (lsnon(k,lsndx(6,2,i)-1+j),k=1,3)
 2009 format(10i5,3(i3,f8.5,e12.5))
  118 continue
  111 continue

      do 44 i=1,nsbnd
      write(lfnout,3007) (lsbnd(j,i),j=1,4),((sbnd(j,i,m),m=1,3),j=1,2)
 3007 format(4i5,3(0pf12.6),3(1pe12.5))
   44 continue

      do 55 i=1,nsang
      write(lfnout,3008) (lsang(j,i),j=1,5),((sang(j,i,m),m=1,3),j=1,2)
 3008 format(5i5,3(0pf12.6),3(1pe12.5))
   55 continue

      do 66 i=1,nsdih
      write(lfnout,3009) (lsdih(j,i),j=1,9),
     & ((sdih(j,i,m,1),m=1,3),j=1,2)
 3009 format(9i5,3(0pf12.6),3(1pe12.5))
      if(lsdih(7,i).lt.0.or.lsdih(8,i).lt.0.or.lsdih(9,i).lt.0) then
      write(lfnout,3009) (lsdih(j,i),j=1,6),(lsdih(j,i),j=14,16),
     & ((sdih(j,i,m,2),m=1,3),j=1,2)
      if(lsdih(14,i).lt.0.or.lsdih(15,i).lt.0.or.lsdih(16,i).lt.0) then
      write(lfnout,3009) (lsdih(j,i),j=1,6),(lsdih(j,i),j=17,19),
     & ((sdih(j,i,m,3),m=1,3),j=1,2)
      endif
      endif
   66 continue

      do 77 i=1,nsimp
      write(lfnout,3010) (lsimp(j,i),j=1,9),((simp(j,i,m),m=1,3),j=1,2)
 3010 format(9i5,3(0pf12.6),3(1pe12.5))
   77 continue

      do 88 i=1,nsnon
      write(lfnout,3011) (lsnon(j,i),j=1,3)
 3011 format(3i5)
   88 continue

#ifdef SKIPIT

      write(lfntop,1000)
 1000 format(/,'UNIQUE SEGMENTS',/)
c
      do 1 i=1,nsgm
      write(lfntop,1001) (csgm(j,i),j=1,1),((lsndx(k,j,i),j=1,2),k=1,6)
 1001 format(/,1x,a5,ix,12i10,//)
      do 2 j=1,lsndx(1,1,i)
      write(lfntop,1002) (lsato(k,lsndx(1,2,i)-1+j),k=1,5),
     & csato(1,lsndx(1,2,i)-1+j)
 1002 format(5i10,1x,a5)
    2 continue
      do 3 j=1,lsndx(2,1,i)
      write(lfntop,1003) (lsbnd(k,lsndx(2,2,i)-1+j),k=1,2)
 1003 format(5i10)
    3 continue
      do 4 j=1,lsndx(3,1,i)
      write(lfntop,1004) (lsang(k,lsndx(3,2,i)-1+j),k=1,3)
 1004 format(5i10)
    4 continue
      do 5 j=1,lsndx(4,1,i)
      write(lfntop,1005) (lsdih(k,lsndx(4,2,i)-1+j),k=1,4)
 1005 format(5i10)
    5 continue
      do 6 j=1,lsndx(5,1,i)
      write(lfntop,1006) (lsimp(k,lsndx(5,2,i)-1+j),k=1,4)
 1006 format(5i10)
    6 continue
      do 7 j=1,lsndx(6,1,i)
      write(lfntop,1007) (lsnon(k,lsndx(6,2,i)-1+j),k=1,3)
 1007 format(5i10)
    7 continue
    1 continue

      do 8 i=1,nsgl
      write(lfntop,1008) csgm(1,lsgl(1,i)),csgm(1,lsgl(2,i)),
     & 1,lsgl(5,i),lsgl(7,i),lsgl(9,i),lsgl(11,i),
     & lsbnd(1,lsgl(4,i)),lsbnd(2,lsgl(4,i))
 1008 format(a5,'-',a5,5i5,/,2i5)
      do 9 j=1,lsgl(5,i)
      write(lfntop,1009) (lsang(m,lsgl(6,i)-1+j),m=1,3)
 1009 format(3i5)
    9 continue
      do 10 j=1,lsgl(7,i)
      write(lfntop,1010) (lsdih(m,lsgl(8,i)-1+j),m=1,4)
 1010 format(4i5)
   10 continue
      do 11 j=1,lsgl(9,i)
      write(lfntop,1011) (lsimp(m,lsgl(10,i)-1+j),m=1,4)
 1011 format(4i5)
   11 continue
      do 12 j=1,lsgl(11,i)
      write(lfntop,1012) (lsnon(m,lsgl(12,i)-1+j),m=1,2)
 1012 format(4i5)
   12 continue
    8 continue

#endif

      return
      end

      subroutine prepare_restart()

      use prepare_data

      implicit none

#include "inp.fh"

      logical lsolvat,lcenter,lwrite

      write(lfnout,333) 0,item
  333 format('DIRECTIVE RESTART',i5,1x,a)

      if(.not.ltop) call prepare_topology()

      lrst=.true.

!     restart options

      lpbc=.false.
      lsolvat=.false.
      lcenter=.false.
      lwrite=.false.
      lbox=.false.

      dgrid=0.1d0
      touch=0.25d0
      xpnd(1)=0.0d0
      xpnd(2)=0.0d0
      xpnd(3)=0.0d0

    1 continue
      if(.not.inp_a(item)) then
      write(lfnout,333) 1,item
    2 continue
      if(.not.inp_read()) then
      item='end'
      return
      else
      if(.not.inp_a(item)) goto 2
      write(lfnout,333) 2,item
      endif
      endif

      write(lfnout,333) 3,item

      if(inp_compare(.false.,'center',item)) then
      lcenter=.true.
      goto 1
      endif

      if(inp_compare(.false.,'grid',item)) then
      if(.not.inp_f(dgrid)) stop 'Error in grid'
      goto 1
      endif

      if(inp_compare(.false.,'touch',item)) then
      if(.not.inp_f(touch)) stop 'Error in touch'
      goto 1
      endif

      if(inp_compare(.false.,'envelope',item)) then
      if(.not.inp_f(xpnd(1))) stop 'Error in envelope'
      if(.not.inp_f(xpnd(2))) xpnd(2)=xpnd(1)
      if(.not.inp_f(xpnd(3))) xpnd(3)=xpnd(2)
      goto 1
      endif

      if(inp_compare(.false.,'solvate',item)) then
      lsolvat=.true.
      goto 1
      endif

      if(inp_compare(.false.,'periodic',item)) then
      lpbc=.true.
      goto 1
      endif

      if(inp_compare(.false.,'vacuo',item)) then
      lpbc=.false.
      goto 1
      endif

      if(inp_compare(.false.,'box',item)) then
      if(.not.inp_f(box(1))) stop 'Error in box'
      if(.not.inp_f(box(2))) stop 'Error in box'
      if(.not.inp_f(box(3))) stop 'Error in box'
      lbox=.true.
      lpbc=.true.
      islv=3
      npbtyp=1
      nbxtyp=1
      goto 1
      endif

      if(inp_compare(.false.,'cube',item)) then
      if(.not.inp_f(box(1))) stop 'Error in cube'
      box(2)=box(1)
      box(3)=box(1)
      lbox=.true.
      lpbc=.true.
      islv=1
      npbtyp=1
      nbxtyp=1
      goto 1
      endif

      if(inp_compare(.false.,'sphere',item)) then
      if(.not.inp_f(box(1))) stop 'Error in sphere'
      box(2)=box(1)
      box(3)=box(1)
      lbox=.true.
      lpbc=.false.
      islv=2
      npbtyp=1
      nbxtyp=1
      goto 1
      endif

      if(inp_compare(.false.,'write',item)) then
      lwrite=.true.
      if(.not.inp_a(item)) stop 'No restart file name'
      filrst=item(1:index(item,' ')-1)//'.rst '
      goto 1
      endif

      call prepare_rst_allocate()
      call prepare_read_topology()
      call prepare_read_pdb()

      if(lcenter) call prepare_center()

      call prepare_missing()

      call prepare_box_size(mwx,nwx)

      if(lsolvat) call prepare_solvate()

      if(lwrite)
     & call prepare_write_restart()

      return
      end

      subroutine prepare_rst_allocate()

      use prepare_data

      implicit none

      integer len,i,j,iw,nw,number
      character*1 char
      real*8 vertop
      character*80 card

!     get the dimensions from the topology file

      len=index(filtop,' ')-1
      open(unit=lfntop,file=filtop(1:len),form='formatted',
     & status='old',err=9999)
      rewind(lfntop)

      read(lfntop,1000) (title(1,i),i=1,3),
     & date,time,ffield,vertop,nparms,
     & natt,nsgm,nsgl,nseq,nato,nmol,nslv,
     & nlnk,nsato,nsbnd,nsang,nsdih,nsimp,nsnon,nunon
 1000 format(a,/,a,/,a,/,3a10,f12.6,/,i3,/,7i10,/,8i10)

      do 3 i=1,natt
      read(lfntop,1001) char
 1001 format(a)
    3 continue
      do 4 i=1,natt
      do 5 j=i,natt
      read(lfntop,1001) char
    5 continue
    4 continue

      do 6 i=1,nsgm
      read(lfntop,1002) nwa
 1002 format(12x,i5)
      read(lfntop,1001) char
    6 continue

      close(unit=lfntop)

!     get the dimensions from the pdb file

      len=index(filpdb,' ')-1
      open(lfnpdb,file=filpdb(1:len),form='formatted',
     & status='old',err=9998)

      nw=0
      nwx=0
    1 continue
      read(lfnpdb,2000,end=2) card
 2000 format(a)
      if(card(1:4).eq.'ATOM'.or.card(1:6).eq.'HETATM') then
      if(card(18:20).eq.namslv) then
      read(card(21:26),2001) iw
 2001 format(i6)
      if(iw.ne.nw) nwx=nwx+1
      nw=iw
      endif
      endif
      goto 1
    2 continue
      mwx=max(1,nwx)
      mwa=nwa

      close(unit=lfnpdb)

!     set the dimensions

      msgm=nsgm
      mseq=nseq+nslv
      msato=nsato
      msa=nato

!     allocate local arrays

      allocate(lsndx(6,2,msgm))
      allocate(csgm(2,msgm))
      allocate(lseq(6,mseq))
      allocate(lsato(8,msato))
      allocate(csato(4,msato))
      allocate(sato(2,msato,3))
      allocate(cs(msa,2))
      allocate(ls(msa,2))
      allocate(xs(msa,3))
      allocate(vs(msa,3))
      allocate(qs(msa))
      allocate(xwx(mwx,mwa,3))
      allocate(vwx(mwx,mwa,3))
      allocate(lwx(mwx,2))
      allocate(cw(mwa,2))

      return

 9999 stop 'Error reading top file'
 9998 stop 'Error reading pdb file'
      return
      end

      subroutine prepare_restart_deallocate()

      use prepare_data

      implicit none

      call ma_summarize_allocated_blocks()

      deallocate(lwx)
      deallocate(vwx)
      deallocate(xwx)

      deallocate(qs)
      deallocate(xs)
      deallocate(ls)
      deallocate(cs)
      deallocate(sato)
      deallocate(csato)
      deallocate(lsato)
      deallocate(lseq)
      deallocate(csgm)
      deallocate(lsndx)

      return
      end

      subroutine prepare_read_topology()

      use prepare_data

      implicit none

      integer len,i,j,k,m
      character*1 char
      real*8 vertop

!     get the dimensions from the topology file

      len=index(filtop,' ')-1
      open(unit=lfntop,file=filtop(1:len),form='formatted',
     & status='old',err=9999)
      rewind(lfntop)

      read(lfntop,1000) (title(1,i),i=1,3),
     & date,time,ffield,vertop,nparms,
     & natt,nsgm,nsgl,nseq,nato,nmol,nslv,
     & nlnk,nsato,nsbnd,nsang,nsdih,nsimp,nsnon,nunon
 1000 format(a,/,a,/,a,/,3a10,f12.6,/,i3,/,7i10,/,8i10)

!     skip the atom type list

      do 1 i=1,natt
      read(lfntop,1001) char
 1001 format(a1)
    1 continue

!     skip the van der Waals parameter list

      do 2 i=1,natt
      do 3 j=i,natt
      read(lfntop,1001) char
    3 continue
    2 continue

!     read the unique segment names and index list

      do 4 i=1,nsgm
      read(lfntop,1004) csgm(1,i),((lsndx(k,j,i),j=1,2),k=1,6)
 1004 format(7x,a5,3(i5,i10),/,12x,3(i5,i10))
    4 continue

!     skip the unique  segment links list

      do 5 i=1,nsgl
      read(lfntop,1001) char
      read(lfntop,1001) char
    5 continue

!     read the solute sequence

      if(nseq.gt.0) then
      read(lfntop,1006) (lseq(1,i),i=1,nseq)
      read(lfntop,1006) (lseq(4,i),i=1,nseq)
      read(lfntop,1006) (lseq(5,i),i=1,nseq)
 1006 format(10i8)
      endif

!     skip the solute links list

      if(nlnk.gt.0) then
      read(lfntop,1007) (k,j=1,nlnk)
      read(lfntop,1007) (k,j=1,nlnk)
      read(lfntop,1007) (k,j=1,nlnk)
 1007 format(10i8)
      endif

!     read the solvents

      do 8 i=1,nslv
      read(lfntop,1008) lseq(1,nseq+i),lseq(5,nseq+i)
 1008 format(2i8)
    8 continue

!     read the atom list

      do 9 i=1,nsato
      read(lfntop,1009) csato(1,i),(lsato(j,i),j=4,8),
     & ((sato(j,i,m),j=1,2),m=1,3)
 1009 format(6x,a5,5i4,6f9.6)
    9 continue

      close(unit=lfntop)

!     determine the actual number of solute atoms

      nsa=0
      do 10 i=1,nseq
      do 11 j=1,lsndx(1,1,lseq(5,i))
      nsa=nsa+1
      ls(nsa,1)=lseq(1,i)
      ls(nsa,2)=0
      cs(nsa,1)=csgm(1,lseq(5,i))
      cs(nsa,2)=csato(1,lsndx(1,2,lseq(5,i))-1+j)
      qs(nsa)=sato(1,lsndx(1,2,lseq(5,i))-1+j,1)
   11 continue
   10 continue

      do 12 j=1,nwa
      cw(j,1)='HOH  '
      cw(j,2)=csato(1,lsndx(1,2,lseq(5,nseq+1))-1+j)
      write(lfnout,444) cw(j,1),cw(j,2)
  444 format('WATNAM ',a,a)
   12 continue

      return

 9999 stop 'Error reading top file'
      return
      end

      subroutine prepare_read_pdb()

      use prepare_data

      implicit none

      logical prepare_namiup
      external prepare_namiup

      integer len,i,j,isgm,mdl,nchain
      character*80 card

      mdl=0
      lslvnt=.false.

      do 10 j=1,3
      do 11 i=1,nsa
      xs(i,j)=0.0d0
      vs(i,j)=0.0d0
   11 continue
   10 continue

!     open the pdb file

      len=index(filpdb,' ')-1
      open(lfnpdb,file=filpdb(1:len),form='formatted',
     & status='old',err=99)

    1 continue

      read(lfnpdb,100,end=999,err=9999) card
  100 format(a)

!     lrgpdb option

      if(card(1:6).eq.'LRGPDB') then
      lrgpdb=1
      goto 1
      endif

!     MODEL

      if(model.ne.mdl) then
      if(card(1:6).eq.'MODEL ') then
      read(card(7:14),102) mdl
  102 format(i8)
      if(model.eq.mdl) then
      write(lfnout,2005) model
 2005 format(10x,'MODEL ',i8)
      endif
      goto 1
      endif
      endif

!     END and ENDMDL

      if(card(1:6).eq.'ENDMDL') then
      if(model.eq.mdl) goto 9
      goto 1
      endif
      if(card(1:6).eq.'END   ') goto 9

!     HEADER

      if(card(1:6).eq.'HEADER') then
      write(lfnout,2001) card
 2001 format(10x,a)
      goto 1
      endif

!     FORMUL

      if(card(1:6).eq.'FORMUL'.and.card(19:19).eq.'*') then
      namslv=card(13:15)
      endif

!     SEQRES

      if(card(1:6).eq.'SEQRES') then
      read(card(14:17),1001) nseq
 1001 format(i4)
      goto 1
      endif

!     SSBOND

      if(card(1:6).eq.'SSBOND') then
      nssb=nssb+1
      goto 1
      endif

!     LINK

      if(card(1:6).eq.'LINK  ') then
      nlnk=nlnk+1
      goto 1
      endif

!     ATOM

      if(card(1:4).eq.'ATOM') then
      if(card(17:17).ne.' '.and.
     & card(17:17).ne.altloc.and.altloc.ne.'*') goto 1
      if(card(22:22).ne.' '.and.
     & card(22:22).ne.chain.and.chain.ne.'*') goto 1
      if(mdl.eq.model) then
      if(card(18:20).eq.namslv) lslvnt=.true.
      if(lrgpdb.eq.0) then
      read(card(23:26),1003) isgm
 1003 format(i4)
      else
      read(card(21:26),1023) isgm
 1023 format(i6)
      endif

      write(lfnout,555) lslvnt,mdl,model,
     & isgm,card(13:17),namslv,card(18:20)
  555 format('ATOM ',l1,1x,3i5,1x,a,1x,a,1x,a)

      if(.not.lslvnt) then
      do 2 i=1,nsa
      if(isgm.eq.ls(i,1).and.card(13:17).eq.cs(i,2)) then
      ls(i,2)=1
      read(card(31:54),1123) (xs(i,j),j=1,3)
 1123 format(3f8.3)
      xs(i,1)=0.1d0*xs(i,1)
      xs(i,2)=0.1d0*xs(i,2)
      xs(i,3)=0.1d0*xs(i,3)
      vs(i,1)=0.0d0
      vs(i,2)=0.0d0
      vs(i,3)=0.0d0
      goto 4
      endif
    2 continue
      do 3 i=1,nsa
      if(ls(i,2).ne.1.and.isgm.eq.ls(i,1)) then
      if(prepare_namiup(card(13:17),cs(i,1),cs(i,2))) then
      ls(i,2)=1
      read(card(31:54),1123) (xs(i,j),j=1,3)
      xs(i,1)=0.1d0*xs(i,1)
      xs(i,2)=0.1d0*xs(i,2)
      xs(i,3)=0.1d0*xs(i,3)
      vs(i,1)=0.0d0
      vs(i,2)=0.0d0
      vs(i,3)=0.0d0
      goto 4
      endif
      endif
    3 continue
    4 continue
      else

      endif

!      if(i.ne.isgm.or.card(22:22).ne.pchain) then
!      if(i+ioff.lt.isgm) ioff=isgm+1-i
!      isgm=i+ioff
!      if(lslvnt) then
!      numslv=numslv+1
!      else
!      nseq=nseq+1
!      nchain=nchain+1
!      endif
!      endif
!      pchain=card(22:22)

      endif
      goto 1
      endif

!     HETATM

      if(card(1:6).eq.'HETATM') then
      if(card(17:17).ne.' '.and.
     & card(17:17).ne.altloc.and.altloc.ne.'*') goto 1
      if(card(22:22).ne.' '.and.
     & card(22:22).ne.chain.and.chain.ne.'*') goto 1
      if(mdl.eq.model) then
      if(card(18:20).eq.namslv) lslvnt=.true.

      read(card(23:26),1004) isgm
 1004 format(i4)

!      if(i.ne.isgm.or.card(22:22).ne.pchain) then
!      isgm=i
!      if(lslvnt) then
!      numslv=numslv+1
!      else
!      nsgm=nsgm+1
!      nchain=nchain+1
!      endif
!      endif
!      pchain=card(22:22)

      endif
      goto 1
      endif

!     TER

      if(card(1:6).eq.'TER   ') then
      nchain=0
      endif

      goto 1

    9 continue

      close(unit=lfnpdb)

      npbtyp=0
      nbxtyp=0
      nsm=0

      return

   99 stop 'Error opening pdb file'
  999 stop 'Unexpected EOF on pdb file'
 9999 stop 'Error reading pdb file'
      return
      end

      logical function prepare_namiup(string,segment,atom)

      implicit none

      character*5 string,segment,atom

      prepare_namiup=.true.

      if(segment.eq.'ARG  ') then
      if(string.eq.' HB2 '.and.atom.eq.'2HB  ') return
      if(string.eq.' HB3 '.and.atom.eq.'3HB  ') return
      if(string.eq.' HD2 '.and.atom.eq.'2HD  ') return
      if(string.eq.' HD3 '.and.atom.eq.'3HD  ') return
      if(string.eq.' HG2 '.and.atom.eq.'2HG  ') return
      if(string.eq.' HG3 '.and.atom.eq.'3HG  ') return
      if(string.eq.'HH11 '.and.atom.eq.'2HH1 ') return
      if(string.eq.'HH12 '.and.atom.eq.'3HH1 ') return
      if(string.eq.'HH21 '.and.atom.eq.'2HH2 ') return
      if(string.eq.'HH22 '.and.atom.eq.'3HH2 ') return
      endif

      if(segment.eq.'ASN  ') then
      if(string.eq.' HB2 '.and.atom.eq.'2HB  ') return
      if(string.eq.' HB3 '.and.atom.eq.'3HB  ') return
      if(string.eq.'HD21 '.and.atom.eq.'2HD2 ') return
      if(string.eq.'HD22 '.and.atom.eq.'3HD2 ') return
      endif

      if(segment.eq.'ASP  ') then
      if(string.eq.' HB2 '.and.atom.eq.'2HB  ') return
      if(string.eq.' HB3 '.and.atom.eq.'3HB  ') return
      endif

      if(segment.eq.'GLN  ') then
      if(string.eq.' HB2 '.and.atom.eq.'2HB  ') return
      if(string.eq.' HB3 '.and.atom.eq.'3HB  ') return
      if(string.eq.' HG2 '.and.atom.eq.'2HG  ') return
      if(string.eq.' HG3 '.and.atom.eq.'3HG  ') return
      if(string.eq.'HE21 '.and.atom.eq.'2HE2 ') return
      if(string.eq.'HE22 '.and.atom.eq.'3HE2 ') return
      endif

      if(segment.eq.'GLY  ') then
      if(string.eq.' HA2 '.and.atom.eq.'2HA  ') return
      if(string.eq.' HA3 '.and.atom.eq.'3HA  ') return
      endif

      if(segment.eq.'GLU  ') then
      if(string.eq.' HB2 '.and.atom.eq.'2HB  ') return
      if(string.eq.' HB3 '.and.atom.eq.'3HB  ') return
      if(string.eq.' HG2 '.and.atom.eq.'2HG  ') return
      if(string.eq.' HG3 '.and.atom.eq.'3HG  ') return
      endif

      if(segment.eq.'HID  ') then
      if(string.eq.' HB2 '.and.atom.eq.'2HB  ') return
      if(string.eq.' HB3 '.and.atom.eq.'3HB  ') return
      endif

      if(segment.eq.'HIE  ') then
      if(string.eq.' HB2 '.and.atom.eq.'2HB  ') return
      if(string.eq.' HB3 '.and.atom.eq.'3HB  ') return
      endif

      if(segment.eq.'HIP  ') then
      if(string.eq.' HB2 '.and.atom.eq.'2HB  ') return
      if(string.eq.' HB3 '.and.atom.eq.'3HB  ') return
      endif

      if(segment.eq.'HIS  ') then
      if(string.eq.' HB2 '.and.atom.eq.'2HB  ') return
      if(string.eq.' HB3 '.and.atom.eq.'3HB  ') return
      endif

      if(segment.eq.'ILE  ') then
      if(string.eq.' CD1 '.and.atom.eq.' CD  ') return
      if(string.eq.'HD11 '.and.atom.eq.'2HD  ') return
      if(string.eq.'HD12 '.and.atom.eq.'3HD  ') return
      if(string.eq.'HD13 '.and.atom.eq.'4HD  ') return
      if(string.eq.'HG12 '.and.atom.eq.'2HG1 ') return
      if(string.eq.'HG13 '.and.atom.eq.'3HG1 ') return
      if(string.eq.'HG21 '.and.atom.eq.'2HG2 ') return
      if(string.eq.'HG22 '.and.atom.eq.'3HG2 ') return
      if(string.eq.'HG23 '.and.atom.eq.'4HG2 ') return
      endif

      if(segment.eq.'LEU  ') then
      if(string.eq.' HB2 '.and.atom.eq.'2HB  ') return
      if(string.eq.' HB3 '.and.atom.eq.'3HB  ') return
      if(string.eq.'HD11 '.and.atom.eq.'2HD1 ') return
      if(string.eq.'HD12 '.and.atom.eq.'3HD1 ') return
      if(string.eq.'HD13 '.and.atom.eq.'4HD1 ') return
      if(string.eq.'HD21 '.and.atom.eq.'2HD2 ') return
      if(string.eq.'HD22 '.and.atom.eq.'3HD2 ') return
      if(string.eq.'HD23 '.and.atom.eq.'4HD2 ') return
      endif

      if(segment.eq.'LYS  ') then
      if(string.eq.' HB2 '.and.atom.eq.'2HB  ') return
      if(string.eq.' HB3 '.and.atom.eq.'3HB  ') return
      if(string.eq.' HG2 '.and.atom.eq.'2HG  ') return
      if(string.eq.' HG3 '.and.atom.eq.'3HG  ') return
      if(string.eq.' HD2 '.and.atom.eq.'2HD  ') return
      if(string.eq.' HD3 '.and.atom.eq.'3HD  ') return
      if(string.eq.' HE2 '.and.atom.eq.'2HE  ') return
      if(string.eq.' HE3 '.and.atom.eq.'3HE  ') return
      if(string.eq.' HZ1 '.and.atom.eq.'2HZ  ') return
      if(string.eq.' HZ2 '.and.atom.eq.'3HZ  ') return
      if(string.eq.' HZ3 '.and.atom.eq.'4HZ  ') return
      endif

      if(segment.eq.'MET  ') then
      if(string.eq.' HB2 '.and.atom.eq.'2HB  ') return
      if(string.eq.' HB3 '.and.atom.eq.'3HB  ') return
      if(string.eq.' HG2 '.and.atom.eq.'2HG  ') return
      if(string.eq.' HG3 '.and.atom.eq.'3HG  ') return
      if(string.eq.' HE1 '.and.atom.eq.'2HE  ') return
      if(string.eq.' HE2 '.and.atom.eq.'3HE  ') return
      if(string.eq.' HE3 '.and.atom.eq.'4HE  ') return
      endif

      if(segment.eq.'PRO  ') then
      if(string.eq.' HB2 '.and.atom.eq.'2HB  ') return
      if(string.eq.' HB3 '.and.atom.eq.'3HB  ') return
      if(string.eq.' HG2 '.and.atom.eq.'2HG  ') return
      if(string.eq.' HG3 '.and.atom.eq.'3HG  ') return
      if(string.eq.' HD2 '.and.atom.eq.'2HD  ') return
      if(string.eq.' HD3 '.and.atom.eq.'3HD  ') return
      endif

      if(segment.eq.'SER  ') then
      if(string.eq.' HB2 '.and.atom.eq.'2HB  ') return
      if(string.eq.' HB3 '.and.atom.eq.'3HB  ') return
      endif

      if(segment.eq.'THR  ') then
      if(string.eq.' HB2 '.and.atom.eq.'2HB  ') return
      if(string.eq.' HB3 '.and.atom.eq.'3HB  ') return
      if(string.eq.'HG21 '.and.atom.eq.'2HG2 ') return
      if(string.eq.'HG22 '.and.atom.eq.'3HG2 ') return
      if(string.eq.'HG23 '.and.atom.eq.'4HG2 ') return
      endif

      if(segment.eq.'TYR  ') then
      if(string.eq.' HB2 '.and.atom.eq.'2HB  ') return
      if(string.eq.' HB3 '.and.atom.eq.'3HB  ') return
      if(string.eq.'HG21 '.and.atom.eq.'2HG2 ') return
      if(string.eq.'HG22 '.and.atom.eq.'3HG2 ') return
      if(string.eq.'HG23 '.and.atom.eq.'4HG2 ') return
      endif

      if(segment.eq.'PHE  ') then
      if(string.eq.' HB2 '.and.atom.eq.'2HB  ') return
      if(string.eq.' HB3 '.and.atom.eq.'3HB  ') return
      endif

      if(segment.eq.'VAL  ') then
      if(string.eq.'HG11 '.and.atom.eq.'2HG1 ') return
      if(string.eq.'HG12 '.and.atom.eq.'3HG1 ') return
      if(string.eq.'HG13 '.and.atom.eq.'4HG1 ') return
      if(string.eq.'HG21 '.and.atom.eq.'2HG2 ') return
      if(string.eq.'HG22 '.and.atom.eq.'3HG2 ') return
      if(string.eq.'HG23 '.and.atom.eq.'4HG2 ') return
      endif

      prepare_namiup=.false.

      return
      end

      subroutine prepare_missing()

      use prepare_data

      implicit none

      logical argos_zmat
      external argos_zmat

      integer i,j,k,l,nmis,nfnd,nskp,lens,lenf
      character*1 char
      character*5 sgmnam
      character*80 card
      real*8 versgm,dz,az,tz,xi(3),xj(3),xk(3),xl(3),qi
      integer na,nb,nh,nd,ni,nz,np,iz,jz,kz,lz,is,ioff

      logical lgr

      lgr=.false.

      do 19 i=1,nsa
      if(ls(i,2).eq.0) then
      write(lfnout,1011) i,ls(i,1),cs(i,1),cs(i,2)
 1011 format('Missing: atom ',i5,' : ',i5,2(a,1x))
      endif
   19 continue

    8 continue

      nmis=0
      nfnd=0

!     apply z-matrix definitions

      is=0
      do 1 i=1,nsa
      if(is.ne.ls(i,1)) then
      ioff=i-1
      is=ls(i,1)
      endif
      if(ls(i,2).eq.0) then
      nmis=nmis+1
      sgmnam=cs(i,1)
      lens=index(sgmnam//' ',' ')-1

      do 2 j=mdirpar,1,-1
      if(nfilpar(j).gt.0) then
      filsgm=
     & dirpar(j)(1:index(dirpar(j),' ')-1)//sgmnam(1:lens)//'.sgm '
      lenf=index(filsgm,' ')-1
      write(lfnout,2001) filsgm(1:lenf)
      open(unit=lfnsgm,file=filsgm(1:lenf),form='formatted',
     & status='old',err=2)
      rewind(unit=lfnsgm)
      goto 3
      endif
    2 continue
      stop 'Could not find sgm file'
    3 continue
   10 continue
      read(lfnsgm,2001,err=999,end=998) card
 2001 format(a)
      if(card(1:1).eq.'#'.or.card(1:1).eq.'$') goto 10
      read(card,2002,err=999,end=998) versgm
 2002 format(f12.6)
      read(lfnsgm,2003,err=999,end=998) na,nb,nh,nd,ni,nz,np
 2003 format(7i5)
      nskp=(na+nb+nh+nd+ni)*(1+np)+np
      do 4 k=1,nskp
      read(lfnsgm,2004,err=999,end=998) char
 2004 format(a)
    4 continue
      do 5 l=1,nz
      read(lfnsgm,2005,end=998,err=999) iz,jz,kz,lz,dz,az,tz
 2005 format(5x,4i5,3f12.6)
      if(i.eq.iz+ioff.and.ls(jz+ioff,2).ne.0.and.ls(kz+ioff,2).ne.0
     & .and.ls(lz+ioff,2).ne.0) then
      do 6 k=1,3
      xj(k)=xs(jz+ioff,k)
      xk(k)=xs(kz+ioff,k)
      xl(k)=xs(lz+ioff,k)
    6 continue
      if(.not.argos_zmat(xi,xj,xk,xl,dz,az,tz))
     & stop 'Error applying z-matrix'
      do 7 k=1,3
      xs(iz+ioff,k)=xi(k)
      vs(iz+ioff,k)=0.0d0
    7 continue
      nmis=nmis-1
      nfnd=nfnd+1
      ls(i,2)=1
      write(lfnout,2015) iz,jz,kz,lz,dz,az,tz,i,ls(i,1),cs(i,1),cs(i,2)
 2015 format(5x,4i5,3f12.6,' applied to ',2i5,2(a,1x))
      else
 2025 format(5x,4i5,3f12.6,' not applied')
      endif
    5 continue
      if(na.eq.1) then

      write(lfnout,1004) box
 1004 format('Single atom segment, box=',3f12.6)

      if(.not.lgr) then
      ngx=nint(box(1)/dgrid)+1
      ngy=nint(box(2)/dgrid)+1
      ngz=nint(box(3)/dgrid)+1
      mgrid=ngx*ngy*ngz
      dgx=box(1)/dble(ngx)
      dgy=box(2)/dble(ngy)
      dgz=box(3)/dble(ngz)
      dx0=-0.5d0*box(1)
      dy0=-0.5d0*box(2)
      dz0=-0.5d0*box(3)
      lgr=.true.

      write(lfnout,1005) ngx,ngy,ngz,dgx,dgy,dgz
 1005 format('Grid dimensions',3i6,3f12.5)

      write(lfnout,1006) dx0,dx0+ngx*dgx,dy0,dy0+ngy*dgy,
     & dz0,dz0+ngz*dgz
 1006 format(6f12.5)

      allocate(lgrid(ngx,ngy,ngz))
      allocate(pgrid(ngx,ngy,ngz))

      call prepare_make_grid()

      endif

      call prepare_pick_grid(xi,qs(i))

      xs(i,1)=xi(1)
      xs(i,2)=xi(2)
      xs(i,3)=xi(3)
      vs(i,1)=0.0d0
      vs(i,2)=0.0d0
      vs(i,3)=0.0d0
      ls(i,2)=1

      endif
      close(unit=lfnsgm)
      endif
    1 continue

      if(nmis.gt.0.and.nfnd.gt.0) goto 8

      if(nmis.gt.0) then
      do 9 i=1,nsa
      if(ls(i,2).eq.0) write(lfnout,1001) i,ls(i,1),cs(i,1),cs(i,2),
     & qs(i)
 1001 format('Not found: atom ',i5,' : ',i5,2x,2(a,1x),f12.5)
    9 continue
      endif

      if(lgr) then
       deallocate(pgrid)
       deallocate(lgrid)
      endif

      return
  998 stop 'EOF segment file'
  999 stop 'ERR segment file'
      return
      end

      subroutine prepare_make_grid()

      use prepare_data

      implicit none

      real*8 xg,yg,zg,d2,dx,dy,dz,t2
      integer i,j,k,l,n

      t2=touch*touch

      n=0
      do 1 k=1,ngz
      do 2 j=1,ngy
      do 3 i=1,ngx
      xg=dx0+(i-1)*dgx
      yg=dy0+(j-1)*dgy
      zg=dz0+(k-1)*dgz
      lgrid(i,j,k)=.true.
      pgrid(i,j,k)=0.0d0
      do 4 l=1,nsa
      dx=abs(xs(l,1)-xg)
      dy=abs(xs(l,2)-yg)
      dz=abs(xs(l,3)-zg)
      if(lpbc) then
      if(dx.gt.0.5d0*box(1)) dx=box(1)-dx
      if(dy.gt.0.5d0*box(2)) dy=box(2)-dy
      if(dz.gt.0.5d0*box(3)) dz=box(3)-dz
      endif
      d2=dx*dx+dy*dy+dz*dz
      if(d2.lt.t2) then
      lgrid(i,j,k)=.false.
      goto 5
      endif
      pgrid(i,j,k)=pgrid(i,j,k)+qs(l)/sqrt(d2)
    4 continue
      n=n+1
    5 continue
    3 continue
    2 continue
    1 continue

      write(lfnout,1000) n,ngx*ngy*ngz
 1000 format('Number of grid points generated is',i6,' out of',i6)

      return
      end

      subroutine prepare_pick_grid(xi,qi)

      use prepare_data

      implicit none

      real*8 xi(3),qi

      integer i,j,k,ii,jj,kk,imax,jmax,kmax,n
      real*8 xg,yg,zg,d2,dx,dy,dz,t2

      write(lfnout,78) lpbc
   78 format('PERIODIC ',l1)

      t2=touch*touch

      imax=0
      jmax=0
      kmax=0
      do 1 k=1,ngz
      do 2 j=1,ngy
      do 3 i=1,ngx
      if(lgrid(i,j,k)) then
      if(imax.eq.0) then
      imax=i
      jmax=j
      kmax=k
      endif
      if((qi.lt.0.0d0.and.pgrid(i,j,k).gt.pgrid(imax,jmax,kmax)).or.
     & (qi.gt.0.0d0.and.pgrid(i,j,k).lt.pgrid(imax,jmax,kmax))) then
      imax=i
      jmax=j
      kmax=k
      endif
      endif
    3 continue
    2 continue
    1 continue

      if(imax.eq.0) stop 'No grid points left'

      xi(1)=dx0+(imax-1)*dgx
      xi(2)=dy0+(jmax-1)*dgy
      xi(3)=dz0+(kmax-1)*dgz

      lgrid(imax,jmax,kmax)=.false.

      n=0

      do 4 k=1,ngz
      do 5 j=1,ngy
      do 6 i=1,ngx
      if(lgrid(i,j,k)) then
      xg=dx0+(i-1)*dgx
      yg=dy0+(j-1)*dgy
      zg=dz0+(k-1)*dgz
      dx=abs(xi(1)-xg)
      dy=abs(xi(2)-yg)
      dz=abs(xi(3)-zg)
      if(lpbc) then
      if(dx.gt.0.5d0*box(1)) dx=box(1)-dx
      if(dy.gt.0.5d0*box(2)) dy=box(2)-dy
      if(dz.gt.0.5d0*box(3)) dz=box(3)-dz
      endif
      d2=dx*dx+dy*dy+dz*dz
      if(d2.lt.t2) then
      lgrid(i,j,k)=.false.
      else
      if(i.eq.1.and.j.eq.1.and.k.eq.1.) 
     & write(lfnout,1000) i,j,k,lgrid(i,j,k),pgrid(i,j,k),
     & pgrid(i,j,k)+qi/sqrt(d2)
 1000 format(3i6,4x,l1,2f12.5)
      pgrid(i,j,k)=pgrid(i,j,k)+qi/sqrt(d2)
      n=n+1
      endif
      endif
    6 continue
    5 continue
    4 continue

      write(lfnout,1001) n
 1001 format('Number of grid points available is',i6)      

      return
      end

      subroutine prepare_write_restart()

      use prepare_data

      implicit none

#include "inp.fh"

      integer :: i,j,k,nats
      real (kind=8) :: temp
      character (len=3) :: sname

      call swatch(datrst,timrst)

      box(1)=box(1)+xpnd(1)
      box(2)=box(2)+xpnd(2)
      box(3)=box(3)+xpnd(3)

      open(unit=lfnrst,file=filrst(1:index(filrst,' ')-1),
     & form='formatted',status='unknown',err=9999)

      write(lfnrst,1001) (title(2,i),i=1,3),version,datrst,timrst,
     & 0,.false.,user
 1001 format(a,/,a,/,a,/,f12.6,2a10,i5,4x,l1,1x,a)
      write(lfnrst,1002) npbtyp,nbxtyp,rsgm,
     & box(1),0.0d0,0.0d0,
     & 0.0d0,box(2),0.0d0,
     & 0.0d0,0.0d0,box(3)
 1002 format(2i5,f12.6,/,(3f12.6))
      write(lfnrst,1003) 0.0d0
 1003 format(e12.5)
      write(lfnrst,1004) 0.0d0,0.0d0,0.0d0
 1004 format(3f12.6)

!     dimensions on the restart file

!     1 i10 nwm   number of solvent molecules
!     2 i10 nwa   number of atoms per solvent molecule
!     3 i10 nsm   number of solute molecules
!     4 i10 nsa   number of solute atoms
!     5 i10 nwx   number of crystal solvent molecules
!     6 i10 nsf   number of solute fractions
!     7 i10 nss   number of solute segments
!     8 i5  nprev number of processors used in previous job
!     9 i5  noe   number of noe constraints

      if(nsa.gt.0) nsm=1
      write(lfnrst,1005) nwx+nwm,nwa,nsm,nsa,nwx,0,nseq,0,0
 1005 format(7i10,2i5)

!     check wich version

      if(nwx.gt.0) then
      do 3 i=1,nwx
      write(lfnrst,1006) ((xwx(i,j,k),k=1,3),(vwx(i,j,k),k=1,3),j=1,nwa)
 1006 format(2x,6f13.8)
      write(lfnrst,1007) 0,(0.0d0,k=1,3)
 1007 format(i1,1x,3f13.8)
    3 continue
      endif

      if(nwm.gt.0) then
      do 4 i=1,nwm
      write(lfnrst,1006) ((xw(i,j,k),k=1,3),(vw(i,j,k),k=1,3),j=1,nwa)
      write(lfnrst,1007) 0,(0.0d0,k=1,3)
    4 continue
      endif

      if(nsa.gt.0) then
      write(lfnrst,1008)
     & (0,(xs(i,k),k=1,3),(vs(i,k),k=1,3),0,i=1,nsa)
 1008 format(i1,1x,6f13.8,i5)
      endif

      if(nsm.gt.0) then
      write(lfnrst,1011) ((0.0d0,k=1,3),i=1,nsm)
 1011 format(2x,3f13.8)
      endif

      close(unit=lfnrst)

      lrgpdb=1

      filpdb=filrst(1:index(filrst,'.rst')-1)//'.pdb '
      open(unit=lfnpdb,file=filpdb(1:index(filpdb,' ')-1),
     & form='formatted',status='unknown',err=9999)

      if(lrgpdb.eq.0) then
      write(lfnpdb,2000) (1.0d1*box(i),i=1,3),90.0,90.0,90.0
 2000 format(
     & 'HEADER',/,
     & 'TITLE     ',/,
     & 'TITLE    2',/,
     & 'TITLE    3',/,
     & 'REMARK   4 XXXX COMPLIES WITH FORMAT V. 2.1, 25-OCT-1996',/,
     & 'CRYST1',3f9.3,3f7.2)
      else
      write(lfnpdb,2001) (1.0d1*box(i),i=1,3),90.0,90.0,90.0
 2001 format(
     & 'HEADER',/,
     & 'TITLE     ',/,
     & 'TITLE    2',/,
     & 'TITLE    3',/,
     & 'REMARK   4 YYYY DOES NOT COMPLY WITH FORMAT V. 2.1,',
     & ' 25-OCT-1996',/,
     & 'CRYST1',3f9.3,3f7.2,/,
     & 'LRGPDB')
      endif

      do 5 i=1,nsa
      temp=4.009103873d1*1.0d0*
     & (vs(i,1)*vs(i,1)+vs(i,2)*vs(i,2)+vs(i,3)*vs(i,3))
      if(temp.gt.999.0) temp=999.999

      if(lrgpdb.eq.0) then
      write(lfnpdb,2003) i,cs(i,2)(1:4),cs(i,1)(1:3),' ',
     & ls(i,1),(1.0d1*xs(i,k),k=1,3),temp
      else
      write(lfnpdb,2004) i,cs(i,2)(1:4),cs(i,1)(1:3),
     & ls(i,1),(1.0d1*xs(i,k),k=1,3),temp
      endif
 2003 format('ATOM',i7,1x,a4,1x,a3,1x,a1,i4,4x,3f8.3,6x,f6.2,4x,a2) 
 2004 format('ATOM',i7,1x,a4,1x,a3,i6,4x,3f8.3,6x,f6.2,4x,a2)
    5 continue

      write(lfnpdb,2005)
 2005 format('TER')

      nats=nsa
      do 6 i=1,nwx
      do 7 j=1,nwa
      nats=nats+1
      temp=4.009103873d1*1.0d0*
     & (vwx(i,j,1)*vwx(i,j,1)+vwx(i,j,2)*vwx(i,j,2)+
     & vwx(i,j,3)*vwx(i,j,3))
      if(temp.gt.999.0) temp=999.999

      if(lrgpdb.eq.0) then
      write(lfnpdb,2003) nats,cw(j,2)(1:4),cw(j,1)(1:3),' ',
     & lwx(i,1),(1.0d1*xwx(i,j,k),k=1,3),temp
      else
      write(lfnpdb,2004) nats,cw(j,2)(1:4),cw(j,1)(1:3),
     & lwx(i,1),(1.0d1*xwx(i,j,k),k=1,3),temp
      endif

    7 continue
    6 continue

      do 8 i=1,nwm
      do 9 j=1,nwa
      nats=nats+1
      temp=4.009103873d1*1.0d0*
     & (vw(i,j,1)*vw(i,j,1)+vw(i,j,2)*vw(i,j,2)+vw(i,j,3)*vw(i,j,3))
      if(temp.gt.999.0) temp=999.999

      if(lrgpdb.eq.0) then
      write(lfnpdb,2003) nats,cw(j,2)(1:4),cw(j,1)(1:3),' ',
     & lw(i,1),(1.0d1*xw(i,j,k),k=1,3),temp
      else
      write(lfnpdb,2004) nats,cw(j,2)(1:4),cw(j,1)(1:3),
     & lw(i,1),(1.0d1*xw(i,j,k),k=1,3),temp
      endif

    9 continue
    8 continue

      close(unit=lfnpdb)

    1 continue
      if(.not.inp_a(item)) then
    2 continue
      if(.not.inp_read()) then
      item='end'
      return
      else
      if(.not.inp_a(item)) goto 2
      endif
      endif

      return
 9999 stop 'Error opening restart file'
      return
      end

      subroutine prepare_box_size()

      use prepare_data

      implicit none

      real*8 bmax
      integer i,j,k

      do 1 k=1,3
      bmax=0.0d0
      do 2 i=1,nsa
      bmax=max(bmax,abs(xs(i,k)))
    2 continue
      do 3 j=1,mwa
      do 4 i=1,nwx
      bmax=max(bmax,abs(xwx(i,j,k)))
    4 continue
    3 continue
      if(lbox) then
      if(bmax.gt.box(k)) then
      stop 'Coordinate outside box '
      endif
      else
      box(k)=bmax
      endif
    1 continue

      write(lfnout,777) box
  777 format('BOX ',t15,3f12.6)

      return
      end

      subroutine prepare_center()

      use prepare_data

      implicit none

      real*8 bmax,bmin,boff
      integer i,j,k

      do 1 k=1,3
      if(nsa.gt.0) then
      bmax=xs(1,k)
      elseif(nwx.gt.0) then
      bmax=xwx(1,1,k)
      endif
      bmin=bmax
      do 2 i=1,nsa
      if(ls(i,2).ne.0) then
      bmin=min(bmin,xs(i,k))
      bmax=max(bmax,xs(i,k))
      endif
    2 continue
      do 3 j=1,mwa
      do 4 i=1,nwx
      bmin=min(bmin,xwx(i,j,k))
      bmax=max(bmax,xwx(i,j,k))
    4 continue
    3 continue
      boff=0.5d0*(bmax+bmin)
      bmax=0.0d0
      do 5 i=1,nsa
      xs(i,k)=xs(i,k)-boff
      bmax=max(bmax,abs(xs(i,k)))
    5 continue
      do 6 j=1,mwa
      do 7 i=1,nwx
      xwx(i,j,k)=xwx(i,j,k)-boff
      bmax=max(bmax,abs(xwx(i,j,k)))
    7 continue
    6 continue
    1 continue

      write(lfnout,777) box
  777 format('BOX CENTERED',t15,3f12.6)

      return
      end

      subroutine prepare_solvate()

      use prepare_data

      implicit none

#include "inp.fh"
#include "util.fh"

      real*8 vslv,vnew

      call prepare_read_solvent()

      vslv=boxs(1)*boxs(2)*boxs(3)
      vnew=box(1)*box(2)*box(3)  

      mwm=int(dble(mws)*1.5d0*(vnew/vslv))

      allocate(lw(mwm,2))
      allocate(xw(mwm,mwa,3))
      allocate(vw(mwm,mwa,3))

      write(lfnout,777) slvmdl(1),nws,mwm,touch,filslv
  777 format('SOLVATE SOLVENT MODEL ',a,1x,2i5,f12.6,1x,a)

      call prepare_apply_solvate()

      return
      end

      subroutine prepare_read_solvent()

      use prepare_data

      implicit none

      character*1 char
      integer i,na,nb,nc,n1,n2,n3
      real*8 rdum

      open(unit=lfnslv,file=filslv(1:index(filslv,' ')-1),
     & status='old',err=9999)

      do 1 i=1,4
      read(lfnslv,1000,err=9998) char
 1000 format(a1)
    1 continue
      read(lfnslv,1001,err=9998) nb
 1001 format(i5)

      if(nb.eq.0) stop 'Solvation restart not periodic'

      read(lfnslv,1002,err=9998) boxs
 1002 format(f12.6,/,12x,f12.6,/,24x,f12.6)
      do 2 i=1,2
      read(lfnslv,1000,err=9998) char
    2 continue

      read(lfnslv,1003,err=9998) nws,na,n2,nc,n1
 1003 format(4i10,30x,i5)

      if(nc.ne.0) stop 'Solvation restart not pure solvent'

      mws=nws

      allocate(xws(mws,mwa,3))
      allocate(vws(mws,mwa,3))

      call prepare_read_solvate_restart()

      close(unit=lfnslv)

      return
 9998 stop 'Error readining solvation restart'
 9999 stop 'Error opening solvation restart'
      return
      end

      subroutine prepare_read_solvate_restart()

      use prepare_data

      implicit none

      integer i,j,k
      character*1 char

      do 1 i=1,nws
      read(lfnslv,1000) ((xws(i,j,k),k=1,3),(vws(i,j,k),k=1,3),j=1,nwa)
 1000 format(2x,6f13.8)
      write(lfnout,555) xws(i,1,1)
  555 format('XSLV ',f12.6)
      read(lfnslv,1001) char
 1001 format(a)
    1 continue

      return
      end

      subroutine prepare_apply_solvate()

      use prepare_data

      implicit none

      real*8 boxh(3),xc(3),x,y,z,dx,dy,dz,touch2

      integer i,j,k,nx,ny,nz,iws,ix,iy,iz
      logical ltry

      write(lfnout,777)
  777 format('APPLY SOLVATE')

      nwm=0

      touch2=touch*touch

      boxh(1)=0.5d0*box(1)
      boxh(2)=0.5d0*box(2)
      boxh(3)=0.5d0*box(3)

      nx=int(box(1)/boxs(1))+2
      ny=int(box(2)/boxs(2))+2
      nz=int(box(3)/boxs(3))+2

      do 4 iws=1,nws
      do 5 k=1,3
      x=0.0d0
      do 6 j=1,nwa
      x=x+xws(iws,j,k)
    6 continue
      xc(k)=x/dble(nwa)
    5 continue

      do 7 ix=-nx,nx
      do 8 iy=-ny,ny
      do 9 iz=-nz,nz

      x=xc(1)+dble(ix)*boxs(1)
      y=xc(2)+dble(iy)*boxs(2)
      z=xc(3)+dble(iz)*boxs(3)

      ltry=.false.
      if(islv.eq.1.or.islv.eq.3) then
      ltry=abs(x).lt.boxh(1).and.abs(y).lt.boxh(2).and.abs(z).lt.boxh(3)
      elseif(islv.eq.2) then
      ltry=(x*x+y*y+z*z).le.boxh(1)*boxh(1)
      endif

      if(ltry) then
      do 10 i=1,nsa
      dx=x-xs(i,1)
      dy=y-xs(i,2)
      dz=z-xs(i,3)
      dx=dx-nint(dx/box(1))*box(1)
      dy=dy-nint(dy/box(2))*box(2)
      dz=dz-nint(dz/box(3))*box(3)
      if(dx*dx+dy*dy+dz*dz.lt.touch2) goto 9
   10 continue

      if(nwx.gt.0) then
      do 11 i=1,nwx
      do 12 j=1,nwa
      dx=x-xwx(i,j,1)
      dy=y-xwx(i,j,2)
      dz=z-xwx(i,j,3)
      dx=dx-nint(dx/box(1))*box(1)
      dy=dy-nint(dy/box(2))*box(2)
      dz=dz-nint(dz/box(3))*box(3)
      if(dx*dx+dy*dy+dz*dz.lt.touch2) goto 9
   12 continue
   11 continue
      endif 

      nwm=nwm+1
      if(nwm.ge.mwm) stop 'Increase mwm'

      do 13 j=1,nwa
      xw(nwm,j,1)=xws(iws,j,1)+dble(ix)*boxs(1)
      xw(nwm,j,2)=xws(iws,j,2)+dble(iy)*boxs(2)
      xw(nwm,j,3)=xws(iws,j,3)+dble(iz)*boxs(3)
      vw(nwm,j,1)=vws(iws,j,1)
      vw(nwm,j,2)=vws(iws,j,2)
      vw(nwm,j,3)=vws(iws,j,3)
      lw(nwm,1)=nwm
      lw(nwm,2)=nwm
   13 continue
      endif

    9 continue
    8 continue
    7 continue
    4 continue

      write(lfnout,1000) nwm
 1000 format('SOLVATE number is',i5)

      return
      end
