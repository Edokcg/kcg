--青眼光龙
function c900000021.initial_effect(c)
	c:EnableReviveLimit()
	
	--特殊召唤方式
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c900000021.spcon)
	e1:SetOperation(c900000021.spop)
	c:RegisterEffect(e1)
	
	--提升攻击
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c900000021.val)
	c:RegisterEffect(e2)
	
	--可以解放自己破坏场上卡片
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(900000021,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c900000021.descost)
	e3:SetTarget(c900000021.destg)
	e3:SetOperation(c900000021.desop)
	c:RegisterEffect(e3)
	
	--发动魔法陷阱效果怪兽时可以选择不受影响
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(900000021,2))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c900000021.discon)
	e4:SetOperation(c900000021.disop)
	c:RegisterEffect(e4)

	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	--c:RegisterEffect(e5)
end
-------------------------------------------------------------------------------------------------------------------------------------------
function c900000021.spcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),Card.IsCode,1,nil,23995346)
end

function c900000021.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(c:GetControler(),Card.IsCode,1,1,nil,23995346)
	Duel.Release(g,REASON_COST)
end
-------------------------------------------------------------------------------------------------------------------------------------------
function c900000021.val(e,c)
	return Duel.GetMatchingGroupCount(Card.IsRace,c:GetControler(),LOCATION_GRAVE,0,nil,RACE_DRAGON)*300
end
-------------------------------------------------------------------------------------------------------------------------------------------
function c900000021.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end

function c900000021.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkaux.TRUE end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end

function c900000021.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_RULE+REASON_EFFECT)
	end
end
-------------------------------------------------------------------------------------------------------------------------------------------
function c900000021.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsStatus(STATUS_BATTLE_DESTROYED) and not c:IsStatus(STATUS_CHAINING)
end

function c900000021.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local tc=re:GetOwner()
	if not ((g and g:IsContains(c)) or g==nil) then return end
	if Duel.SelectYesNo(e:GetHandlerPlayer(),aux.Stringid(1639384,0)) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(function(e, te)
			return te==re
		end)
		e1:SetReset(RESET_CHAIN)
		c:RegisterEffect(e1)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_CHAIN_SOLVED)
		e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
		e4:SetRange(LOCATION_MZONE)
		e4:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			if g and g:IsContains(c) and tc then
				tc:CancelCardTarget(c)
				tc:ReleaseRelation(c)
			end
		end)
		e4:SetReset(RESET_CHAIN)
		c:RegisterEffect(e4)
	end
end
