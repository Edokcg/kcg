--混沌战士-开辟的使者(ZCG)
function c77239695.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,8,2)
	c:EnableReviveLimit()
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c77239695.splimit)
	c:RegisterEffect(e1)	
 
	--xyz summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetDescription(aux.Stringid(77239695,0))
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(SUMMON_TYPE_XYZ)
	e2:SetCondition(c77239695.spcon)
	e2:SetOperation(c77239695.spop)
	c:RegisterEffect(e2)
	
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetTargetRange(LOCATION_HAND,0)
	e3:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e3)

	--skip draw
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetCondition(c77239695.skipcon)
	e4:SetOperation(c77239695.skipop)
	c:RegisterEffect(e4)

	--chain attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77239695,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCountLimit(1)
	e3:SetCondition(c77239695.atcon)
	e3:SetOperation(c77239695.atop)
	c:RegisterEffect(e3)	
end
-----------------------------------------------------------------------------------
function c77239695.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
-----------------------------------------------------------------------------------
function c77239695.spfilter(c)
	return c:GetLevel()==8
end
function c77239695.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return false end
	return Duel.IsExistingMatchingCard(c77239695.spfilter,tp,LOCATION_HAND,0,2,nil,tp,c)
end
function c77239695.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g1=Duel.SelectMatchingCard(tp,c77239695.spfilter,tp,LOCATION_HAND,0,2,2,nil,nil)
	e:GetHandler():SetMaterial(g1)
	Duel.Overlay(e:GetHandler(),g1)  
end
-----------------------------------------------------------------------------------
function c77239695.skipcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c77239695.skipop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCode(EFFECT_SKIP_DP)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
end
-----------------------------------------------------------------------------------
function c77239695.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c and aux.bdocon(e,tp,eg,ep,ev,re,r,rp) and c:GetFlagEffect(77239695)==0
		--and c:IsChainAttackable()
end
function c77239695.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end



