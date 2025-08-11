--三国传-吕布·炎
function c77238655.initial_effect(c)
	c:EnableReviveLimit()
	--special summon summon from hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77238655,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetCondition(c77238655.hspcon)
	e1:SetTarget(c77238655.hsptg)
	e1:SetOperation(c77238655.hspop)
	c:RegisterEffect(e1,false,EFFECT_MARKER_CARDIAN)
    --[[cannot special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e1)
    --tribute limit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_TRIBUTE_LIMIT)
    e2:SetValue(c77238655.tlimit)
    c:RegisterEffect(e2)
    --summon with 3 tribute
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(77238655,0))
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e3:SetCode(EFFECT_LIMIT_SUMMON_PROC)
    e3:SetCondition(c77238655.ttcon)
    e3:SetOperation(c77238655.ttop)
    e3:SetValue(SUMMON_TYPE_ADVANCE)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_LIMIT_SET_PROC)
    c:RegisterEffect(e4)]]

    --
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_DESTROY)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(EVENT_SPSUMMON_SUCCESS)
    e5:SetTarget(c77238655.target)
    e5:SetOperation(c77238655.activate)
    c:RegisterEffect(e5)	
	
    --damage
    local e6=Effect.CreateEffect(c)
    e6:SetCategory(CATEGORY_DAMAGE)
    e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e6:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCountLimit(1)
    e6:SetCondition(c77238655.damcon)
    e6:SetTarget(c77238655.damtg)
    e6:SetOperation(c77238655.damop)
    c:RegisterEffect(e6)	
end

--[[function c77238655.tlimit(e,c)
    return not c:IsSetCard(0xa300)
end
function c77238655.ttcon(e,c,minc)
    if c==nil then return true end
    return minc<=3 and Duel.CheckTribute(c,3)
end
function c77238655.ttop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.SelectTribute(tp,c,3,3)
    c:SetMaterial(g)
    Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end]]

function c77238655.hspfilter(c,tp)
	return c:IsSetCard(0xa300)
end
function c77238655.hspcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),c77238655.hspfilter,1,false,1,true,c,c:GetControler(),nil,false,nil)
end
function c77238655.hsptg(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,c77238655.hspfilter,1,3,false,true,true,c,nil,nil,false,nil)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
	return true
	end
	return false
end
function c77238655.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Release(g,REASON_COST)
	g:DeleteGroup()
end

function c77238655.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77238655.activate(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
    Duel.Destroy(sg,REASON_EFFECT)
end
--------------------------------------------------------------------
function c77238655.damcon(e,tp,eg,ep,ev,re,r,rp)
    return tp==Duel.GetTurnPlayer()
end
function c77238655.damfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xa300)
end
function c77238655.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local ct=Duel.GetMatchingGroupCount(c77238655.damfilter,tp,LOCATION_ONFIELD,0,nil)
    Duel.SetTargetPlayer(1-tp)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*300)
end
function c77238655.damop(e,tp,eg,ep,ev,re,r,rp)
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    local ct=Duel.GetMatchingGroupCount(c77238655.damfilter,tp,LOCATION_ONFIELD,0,nil)
    Duel.Damage(p,ct*500,REASON_EFFECT)
end




