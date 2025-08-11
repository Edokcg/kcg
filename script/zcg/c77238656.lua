--三国传-吕布·暗
function c77238656.initial_effect(c)
	c:EnableReviveLimit()
	--special summon summon from hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77238655,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetCondition(c77238656.hspcon)
	e1:SetTarget(c77238656.hsptg)
	e1:SetOperation(c77238656.hspop)
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
    e2:SetValue(c77238656.tlimit)
    c:RegisterEffect(e2)
    --summon with 3 tribute
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(77238656,0))
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e3:SetCode(EFFECT_LIMIT_SUMMON_PROC)
    e3:SetCondition(c77238656.ttcon)
    e3:SetOperation(c77238656.ttop)
    e3:SetValue(SUMMON_TYPE_ADVANCE)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_LIMIT_SET_PROC)
    c:RegisterEffect(e4)]]
	
    --
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_DESTROY)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EVENT_SPSUMMON_SUCCESS)
    e5:SetOperation(c77238656.activate)
    c:RegisterEffect(e5)

    --atk
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_SET_ATTACK_FINAL)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_REPEAT+EFFECT_FLAG_DELAY)
    e6:SetRange(LOCATION_MZONE)
    e6:SetValue(c77238656.adval)
    c:RegisterEffect(e6)
    local e7=e6:Clone()
    e7:SetCode(EFFECT_SET_DEFENSE_FINAL)
    c:RegisterEffect(e7)
end

--[[function c77238656.tlimit(e,c)
    return not c:IsSetCard(0xa300)
end
function c77238656.ttcon(e,c,minc)
    if c==nil then return true end
    return minc<=1 and Duel.CheckTribute(c,1)
end
function c77238656.ttop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.SelectTribute(tp,c,1,1)
    c:SetMaterial(g)
    Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end]]

function c77238656.hspfilter(c,tp)
	return c:IsSetCard(0xa300)
end
function c77238656.hspcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),c77238656.hspfilter,1,false,1,true,c,c:GetControler(),nil,false,nil)
end
function c77238656.hsptg(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,c77238656.hspfilter,1,1,false,true,true,c,nil,nil,false,nil)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
	return true
	end
	return false
end
function c77238656.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Release(g,REASON_COST)
	g:DeleteGroup()
end

function c77238656.activate(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetTargetRange(0,1)
    e1:SetValue(c77238656.aclimit)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
    Duel.RegisterEffect(e1,tp)
end
function c77238656.aclimit(e,re,tp)
    return re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
--------------------------------------------------------------------
function c77238656.adval(e,c)
    local g=Duel.GetMatchingGroup(nil,0,LOCATION_GRAVE,LOCATION_GRAVE,nil)
    if g:GetCount()==0 then
        return 500
    else
        local sg,val=g:GetMaxGroup(Card.GetAttack)
        return val+500
    end
end
