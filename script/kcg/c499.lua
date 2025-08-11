--Lyrical Luscinia - Independent Nightingale
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,497,s.ffilter)
	
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(s.effcon)
	e0:SetOperation(s.spsumsuc)
	c:RegisterEffect(e0)
	
	--level
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(s.valcheck)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_LEVEL)
	e2:SetCondition(s.lvcon)
	e2:SetValue(s.lvval)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)

	--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(s.efilter)
	c:RegisterEffect(e5)

	--Atk update
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SET_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(s.atkval)
	c:RegisterEffect(e3)

	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(17415895,0))
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(s.target)
	e4:SetOperation(s.operation)
	c:RegisterEffect(e4)

	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SPSUMMON_CONDITION)
	e5:SetValue(s.fusfilter)
	c:RegisterEffect(e5)
end
s.listed_names={497}

function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and re and re:GetHandler():IsCode(497)
end
function s.spsumsuc(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	local ag=g:Remove(Card.IsCode,c,497)
	if #ag~=1 then return end
	local tc=ag:GetFirst()
	if not tc:IsType(TYPE_XYZ) or tc:GetOriginalRank()>12 then return end
	c:SetCardData(CARDDATA_SETCODE, {tc:GetOriginalSetCard()})
	c:SetCardData(CARDDATA_ATTRIBUTE, tc:GetOriginalAttribute())
	c:SetCardData(CARDDATA_RACE, tc:GetOriginalRace())
	c:SetCardData(CARDDATA_ATTACK, tc:GetTextAttack()+1000)
	c:SetCardData(CARDDATA_LEVEL, tc:GetOriginalRank())
end

function s.ffilter(c,fc,sumtype,tp)
	return c:IsType(TYPE_XYZ,fc,sumtype,tp) and c:GetOriginalRank()<13
end

function s.valcheck(e,c)
	local g=c:GetMaterial()
	local ag=g:Remove(Card.IsCode,c,497)
	if #ag~=1 then return end
	local tc=ag:GetFirst()
	if not tc:IsType(TYPE_XYZ) then return end
	local lvl=tc:GetOverlayCount()
	e:SetLabel(lvl)
end
function s.lvcon(e)
	return (e:GetHandler():GetSummonType()&SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function s.lvval(e,c)
	return e:GetLabelObject():GetLabel()
end

function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end

function s.atkval(e,c)
	local c=e:GetHandler()
	local atk=c:GetBaseAttack()+(c:GetLevel()*500)
	if atk<0 then atk=0 end
	return atk
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetLevel()>0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local dam=e:GetHandler():GetLevel()*500
	Duel.Damage(p,dam,REASON_EFFECT)
end

function s.fusfilter(e,se,sp,st)
	return se:GetHandler():IsCode(497)
end
