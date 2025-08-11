--ゴッドアイズ・ファントム・ドラゴン
local s, id = GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Pendulum.AddProcedure(c)

    --spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(s.penlimit)
	c:RegisterEffect(e0)

    --avoid damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(1,0)
	e1:SetCondition(s.damcon)
	e1:SetValue(s.damval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e2)

    --reduce tribute
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40227329,4))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetTargetRange(LOCATION_HAND,0)
	e3:SetCode(EFFECT_SUMMON_PROC)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.ntcon)
	e3:SetTarget(s.nttg)
	c:RegisterEffect(e3)

	--special summon
    local e4 = Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(10000080, 1))
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE + EFFECT_FLAG_SPSUM_PARAM)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_SPSUMMON_PROC)
    e4:SetRange(LOCATION_HAND+LOCATION_EXTRA)
    e4:SetTargetRange(POS_FACEUP_ATTACK, 1)
    e4:SetCondition(s.hspcon)
    e4:SetOperation(s.hspop)
    c:RegisterEffect(e4)  

	--special summon limit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e6:SetTargetRange(1,0)
    e6:SetCondition(s.splimcon)
	e6:SetTarget(s.sumlimit)
	e6:SetLabelObject(e4)
	c:RegisterEffect(e6)
	
    local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_DISABLE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(LOCATION_MZONE,0)
    e8:SetCondition(s.splimcon)
	e8:SetTarget(s.sumlimit2)
    e8:SetLabelObject(e4)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e9)  

    local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e10:SetCode(EVENT_PHASE+PHASE_END)
	e10:SetRange(LOCATION_MZONE)
    e10:SetCountLimit(1)
    e10:SetCondition(s.endcon)
	e10:SetOperation(s.endop)
	c:RegisterEffect(e10)

    local e11 = Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_SINGLE)
    e11:SetCode(EFFECT_CANNOT_ATTACK)
    c:RegisterEffect(e11)
    local e12 = e11:Clone()
    e12:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e12:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
    e12:SetRange(LOCATION_MZONE)
    c:RegisterEffect(e12)

    local e13 = Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_SINGLE)
    e13:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e13:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
    e13:SetRange(LOCATION_MZONE)
    e13:SetValue(aux.imval1)
    c:RegisterEffect(e13)

    local e14 = Effect.CreateEffect(c)
    e14:SetType(EFFECT_TYPE_SINGLE)
    e14:SetProperty(EFFECT_FLAG_SINGLE_RANGE + EFFECT_FLAG_CANNOT_DISABLE)
    e14:SetRange(LOCATION_MZONE)
    e14:SetCode(EFFECT_IMMUNE_EFFECT)
    e14:SetValue(s.efilterr)
    c:RegisterEffect(e14)
end
s.listed_series = {0x903, 0x1903}

function s.penlimit(e,se,sp,st)
	return (st&SUMMON_TYPE_PENDULUM==SUMMON_TYPE_PENDULUM and not e:GetHandler():IsLocation(LOCATION_HAND))
	or (e:GetHandler():IsLocation(LOCATION_GRAVE+LOCATION_REMOVED))
end

function s.damcon(e)
	return e:GetHandler():GetFlagEffect(40227329)==0
end
function s.damval(e,re,val,r,rp,rc)
	local c=e:GetHandler()
	if bit.band(r,REASON_EFFECT)~=0 and c:GetFlagEffect(40227329)==0 then
		c:RegisterFlagEffect(40227329,RESET_PHASE+PHASE_END,0,1)
		return 0
	end
	return val
end

function s.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function s.nttg(e,c)
	return c:IsLevelAbove(5) and c:IsSetCard(0x903)
end

function s.hspcon(e, c, minc, zone, relzone, exeff)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetReleaseGroup(tp)
	return g:GetCount()>=1 and g:FilterCount(Card.IsReleasable,nil)==g:GetCount()
		and (c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(1-tp,tp,g,c)>0
			or c:IsLocation(LOCATION_HAND) and Duel.GetMZoneCount(1-tp,g,tp)>0)
end
function s.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetReleaseGroup(tp)
	Duel.Release(g,REASON_COST)
	local g2=Duel.GetOperatedGroup()
	if #g2<1 then return end
	local ssumtype=0
    if g2:FilterCount(s.hspfilterf,nil)>0 then ssumtype=ssumtype+TYPE_FUSION end
    if g:FilterCount(s.hspfilters,nil)>0 then ssumtype=ssumtype+TYPE_SYNCHRO end
    if g:FilterCount(s.hspfilterx,nil)>0 then ssumtype=ssumtype+TYPE_XYZ end
    if g:FilterCount(s.hspfilterp,nilM)>0 then ssumtype=ssumtype+TYPE_PENDULUM end
    if g:FilterCount(s.hspfilterl,nil)>0 then ssumtype=ssumtype+TYPE_LINK end
	e:SetLabel(ssumtype)
end
function s.hspfilterf(c)
	return c:IsSetCard(0x1903) and bit.band(c:GetPreviousTypeOnField(),TYPE_FUSION)~=0
end
function s.hspfilters(c)
	return c:IsSetCard(0x1903) and bit.band(c:GetPreviousTypeOnField(),TYPE_SYNCHRO)~=0
end
function s.hspfilterx(c)
	return c:IsSetCard(0x1903) and bit.band(c:GetPreviousTypeOnField(),TYPE_XYZ)~=0
end
function s.hspfilterp(c)
	return c:IsSetCard(0x1903) and bit.band(c:GetPreviousTypeOnField(),TYPE_PENDULUM)~=0
end
function s.hspfilterl(c)
	return c:IsSetCard(0x1903) and bit.band(c:GetPreviousTypeOnField(),TYPE_LINK)~=0
end

function s.splimcon(e)
    local stype=e:GetLabelObject():GetLabel()
	return stype and stype>0
end
function s.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
    local stype=e:GetLabelObject():GetLabel()
	local ssumtype=0
    if bit.band(stype,TYPE_FUSION)~=0 then ssumtype=ssumtype+SUMMON_TYPE_FUSION end
    if bit.band(stype,TYPE_SYNCHRO)~=0 then ssumtype=ssumtype+SUMMON_TYPE_SYNCHRO end
    if bit.band(stype,TYPE_XYZ)~=0 then ssumtype=ssumtype+SUMMON_TYPE_XYZ end
    if bit.band(stype,TYPE_PENDULUM)~=0 then ssumtype=ssumtype+SUMMON_TYPE_PENDULUM end
    if bit.band(stype,TYPE_LINK)~=0 then ssumtype=ssumtype+SUMMON_TYPE_LINK end
	return bit.band(sumtype,ssumtype)~=0
end

function s.sumlimit2(e,c)
    local stype=e:GetLabelObject():GetLabel()
	return c:IsType(stype)
end

function s.endcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.endop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetTurnPlayer()~=tp then return end
	Duel.SetLP(tp, 0)
end

function s.efilterr(e, te)
    return te:GetOwner() ~= e:GetOwner()
end
